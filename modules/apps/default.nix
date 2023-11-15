{ config, lib, ... }:

let
  cfg = config.modules.apps;
in
{
  options.modules.apps = {
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra packages to install";
    };
  };

  config.hm.home.packages = cfg.extraPackages;
}
