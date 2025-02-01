{ config, lib, pkgs, ... }:

let cfg = config.modules.services.locate;
in {
  options.modules.services.locate = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable locate service";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.plocate;
      description = "The locate implementation to use";
    };
    interval = lib.mkOption {
      type = lib.types.str;
      default = "hourly";
      description = "Update the local database as this interval.";
    };
  };

  config = lib.mkMerge [
    {
      services.locate = {
        enable = cfg.enable;
        package = cfg.package;
        interval = cfg.interval;
      };
    }

    (lib.mkIf (cfg.package == pkgs.mlocate) { users.groups.mlocate = { }; })
  ];
}
