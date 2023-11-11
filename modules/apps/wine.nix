{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.apps.wine;
in {
  options.modules.apps.wine = {
    enable = mkEnableOption "Whether to enable Wine";
    waylandSupport = mkOption {
      type = types.bool;
      default = config.modules.desktop.tiling-wm.wayland.enable;
      description = "Whether to enable Wayland support";
    };
    winetricks.enable = mkEnableOption "Whether to install Winetricks";
    bottles.enable = mkEnableOption "Whether to install bottles";
  };

  config = mkIf cfg.enable {
    hm.home.packages = with pkgs; [
      (if cfg.waylandSupport then
        wineWowPackages.waylandFull
      else
        wineWowPackages.full)

      (mkIf cfg.winetricks.enable winetricks)

      (mkIf cfg.bottles.enable bottles)
    ];

    environment.sessionVariables = { WINEDEBUG = "-all"; };
  };
}
