{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf mkForce types;
  cfg = config.modules.apps.wine;
in
{
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
    hm.home.packages = [
      pkgs.wineWowPackages.stagingFull

      (mkIf cfg.winetricks.enable pkgs.winetricks)

      (mkIf cfg.bottles.enable pkgs.bottles)
    ];

    hm.home.sessionVariables = { WINEDEBUG = "-all"; };

    modules.system.pipewire.support32Bit = mkForce true;
    modules.system.nvidia.support32Bit = mkForce true;

    modules.system.persist.state.home.directories = [
      ".local/share/bottles"
      ".wine"
    ];
  };
}
