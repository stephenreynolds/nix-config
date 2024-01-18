{ config, lib, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkMerge mkBefore mkForce types;
  cfg = config.modules.system.ephemeral-root;
in
{
  options.modules.system.ephemeral-root = {
    btrfs = {
      enable = mkEnableOption "Whether to use a btrfs subvolume as root";
    };
    tmpfs = {
      enable = mkEnableOption "Whether to use a tmpfs as root";
      size = mkOption {
        type = types.str;
        default = "4G";
        description = "The maximimum size of the tmpfs";
      };
    };
  };

  config = mkMerge [
    {
      assertions = [{
        assertion = !(cfg.btrfs.enable && cfg.tmpfs.enable);
        message = "Only one of btrfs.enable or tmpfs.enable can be true";
      }];
    }

    (mkIf cfg.tmpfs.enable {
      fileSystems."/" = mkForce {
        device = "none";
        fsType = "tmpfs";
        options = [ "defaults" "size=${cfg.tmpfs.size}" "mode=755" ];
      };
    })

    (mkIf cfg.btrfs.enable {
      boot.initrd =
        let
          hostname = config.networking.hostName;
          wipeScript = /* bash */ ''
            mkdir -p /tmp
            MNTPOINT=$(mktemp -d)
            (
              mount /dev/disk/by-label/${hostname} "$MNTPOINT"
              trap 'umount "$MNTPOINT"' EXIT

              if [[ -e "/$MNTPOINT/root" ]]; then
                mkdir -p "/$MNTPOINT/old_roots"
                timestamp=$(date --date="@$(stat -c %Y /$MNTPOINT/root)" "+%Y-%m-%-d_%H:%M:%S")
                mv /$MNTPOINT/root "/$MNTPOINT/old_roots/$timestamp"
              fi

              delete_subvolume_recursively() {
                IFS=$'\n'
                for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/$MNTPOINT/$i"
                done
                btrfs subvolume delete "$1"
              }

              for i in $(find "/$MNTPOINT/old_roots/" -maxdepth 1 -mtime +30); do
                delete_subvolume_recursively "$i"
              done

              btrfs subvolume create "/$MNTPOINT/root"
            )
          '';
          phase1Systemd = config.boot.initrd.systemd.enable;
        in
        {
          supportedFilesystems = [ "btrfs" ];
          postDeviceCommands = mkIf (!phase1Systemd) (mkBefore wipeScript);
          systemd.services.restore-root = mkIf phase1Systemd {
            description = "Rollback btrfs root";
            wantedBy = [ "initrd.target" ];
            requires = [ "dev-disk-by\\x2dlabel-${hostname}.device" ];
            after = [
              "dev-disk-by\\x2dlabel-${hostname}.device"
              "systemd-cryptsetup@${hostname}.service"
            ];
            before = [ "sysroot.mount" ];
            unitConfig.DefaultDependencies = "no";
            serviceConfig.Type = "oneshot";
            script = wipeScript;
          };
        };
    })
  ];
}

