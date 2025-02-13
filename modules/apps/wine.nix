{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf mkForce types;
  cfg = config.modules.apps.wine;
in
{
  options.modules.apps.wine = {
    enable = mkEnableOption "Whether to enable Wine";
    package = mkOption {
      type = types.package;
      default = pkgs.wineWowPackages.waylandFull;
      description = "The package of Wine to install";
    };
    waylandSupport = mkOption {
      type = types.bool;
      default = config.modules.desktop.tiling-wm.wayland.enable;
      description = "Whether to enable Wayland support";
    };
    debug = mkEnableOption "Whether to enable debuggin info";
    winetricks.enable = mkEnableOption "Whether to install Winetricks";
    bottles.enable = mkEnableOption "Whether to install bottles";
  };

  config = mkIf cfg.enable {
    hm.home.packages = [
      cfg.package

      (mkIf cfg.winetricks.enable pkgs.winetricks)

      (mkIf cfg.bottles.enable pkgs.bottles)
    ];

    hm.home.sessionVariables = mkIf cfg.debug {
      WINEDEBUG = "-all";
    };

    modules.system.pipewire.support32Bit = mkForce true;
    modules.system.nvidia.support32Bit = mkForce true;

    modules.system.persist.state.home.directories = [
      ".local/share/bottles"
      ".wine"
    ];
  };
}
