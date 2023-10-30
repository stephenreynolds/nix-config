{ config, lib, ... }:
with lib;
let cfg = config.modules.system.security;
in {
  options.modules.system.security = {
    boot = {
      tmpOnTmpfs = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to mount a tmpfs on /tmp during boot.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.boot.tmpOnTmpfs {
      boot = {
        tmp = {
          useTmpfs = true;
          cleanOnBoot = !config.boot.tmp.useTmpfs;
        };
      };
    })
  ];
}
