{ config, lib, ... }:

let cfg = config.modules.system.security;
in {
  options.modules.system.security = {
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
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable mitigations for known CPU vulnerabilities
        '';
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.boot.tmpOnTmpfs {
      boot = {
        tmp = {
          useTmpfs = true;
          cleanOnBoot = !config.boot.tmp.useTmpfs;
        };
      };
    })

    (lib.mkIf (!cfg.mitigations.enable) {
      boot.kernelParams = [ "mitigations=off" ];
    })
  ];
}
