{ config, lib, ... }:

let cfg = config.my.system.security;
in {
  imports = [
    ./secure-boot.nix
    ./tpm.nix
  ];

  options.my.system.security = {
    boot = {
      tmpOnTmpfs = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to mount a tmpfs on /tmp during boot.
        '';
      };
    };
    mitigations = {
      disable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable mitigations for known CPU vulnerabilities
        '';
      };
    };
    systemd = {
      coredump = {
        disable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to disable systemd core dumps
          '';
        };
      };
    };
  };

  config = lib.mkMerge [
    {
      systemd.coredump.enable = !cfg.systemd.coredump.disable;

      security.chromiumSuidSandbox.enable = true;
    }

    (lib.mkIf cfg.boot.tmpOnTmpfs {
      boot = {
        tmp = {
          useTmpfs = true;
          cleanOnBoot = !config.boot.tmp.useTmpfs;
        };
      };
    })

    (lib.mkIf (cfg.mitigations.disable) {
      boot.kernelParams = [ "mitigations=off" ];
    })
  ];
}
