{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.services.locate;
in {
  options.modules.services.locate = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable locate service";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.plocate;
      description = "The locate implementation to use";
    };
    interval = mkOption {
      type = types.str;
      default = "hourly";
      description = "Update the local database as this interval.";
    };
  };

  config = mkMerge [
    {
      services.locate = {
        enable = cfg.enable;
        package = cfg.package;
        interval = cfg.interval;
      };
    }

    # Suppress "mlocate and plocate do not support localuser" warning
    (mkIf (cfg.package == pkgs.mlocate || cfg.package == pkgs.plocate) {
      services.locate.localuser = null;
    })
  ];
}
