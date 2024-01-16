{ config, lib, inputs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkMerge mkBefore types optionalString attrValues concatLines;
  cfg = config.my.system.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.my.system.impermanence = {
    enable = mkEnableOption "Whether to enable opt-in persistence";
    wipeMethod = mkOption {
      type = types.enum [ "btrfs" "tmpfs" ];
      default = "tmpfs";
      description = "The method used to wipe the root filesystem";
    };
    persist = {
      path = mkOption {
        type = types.str;
        default = "/persist";
        description = "The path where files are persisted to";
      };
      directories = mkOption {
        type = with types; listOf (either str attrs);
        default = [ ];
        description = "Directories to persist";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.persistence = {
        "${cfg.persist.path}" = {
          directories = cfg.persist.directories ++ [
            "/var/lib/systemd"
            "/var/lib/nixos"
            "/var/log"
          ];
        };
      };

      programs.fuse.userAllowOther = true;

      system.activationScripts.persistent-dirs.text =
        let
          mkHomePersist = user: optionalString user.createHome ''
            mkdir -p ${cfg.persist.path}/${user.home}
            chown ${user.name}:${user.group} ${cfg.persist.path}/${user.home}
            chmod ${user.homeMode} ${cfg.persist.path}/${user.home}
          '';
          users = attrValues config.users.users;
        in
        concatLines (map mkHomePersist users);
    }

    (mkIf (cfg.wipeMethod == "btrfs") {
      boot.initrd =
        let
          hostname = config.networking.hostName;
          wipeScript = /* bash */ ''
            mkdir -p /tmp
            MNTPOINT=$(mktemp -d)
            (
              mount /dev/disk/by-label/${hostname} "$MNTPOINT"
              trap 'umount "$MNTPOINT"' EXIT

              if [[ -e /tmp/root ]]; then
                mkdir -p /tmp/old_roots
                timestamp=$(date --date="@$(stat -c %Y /tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
                mv /tmp/root "/tmp/old_roots/$timestamp"
              fi

              delete_subvolume_recursively() {
                IFS=$'\n'
                for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/tmp/$i"
                done
                btrfs subvolume delete "$1"
              }

              for i in $(find /tmp/old_roots/ -maxdepth 1 -mtime +30); do
                delete_subvolume_recursively "$i"
              done

              btrfs subvolume create /tmp/root
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
  ]);
}
