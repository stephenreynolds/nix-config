{ config, lib, pkgs, ... }:

let
  inherit (lib) types mkOption mkEnableOption mkIf;
  cfg = config.my.apps.wine;
in
{
  options.my.apps.wine = {
    enable = mkEnableOption "Whether to enable Wine";
    waylandSupport = mkOption {
      type = types.bool;
      default = config.my.desktop.tiling-wm.wayland.enable;
      description = "Whether to enable Wayland support";
    };
    winetricks.enable = mkEnableOption "Whether to install Winetricks";
    bottles.enable = mkEnableOption "Whether to install bottles";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (if cfg.waylandSupport then
        wineWowPackages.waylandFull
      else
        wineWowPackages.full)

      (mkIf cfg.winetricks.enable winetricks)

      (mkIf cfg.bottles.enable bottles)
    ];
  };
}
