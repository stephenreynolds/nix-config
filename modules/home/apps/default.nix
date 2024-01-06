{ config, lib, ... }:

let
  cfg = config.my.apps;
in
{
  options.my.apps = {
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra packages to install";
    };
  };

  config.home.packages = cfg.extraPackages;
}
