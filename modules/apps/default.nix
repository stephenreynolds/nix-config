{ config, lib, ... }:
with lib;
let cfg = config.modules.apps;
in {
  options.modules.apps = {
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra packages to install";
    };
  };

  config.hm.home.packages = cfg.extraPackages;
}
