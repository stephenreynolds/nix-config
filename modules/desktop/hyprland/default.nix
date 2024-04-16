{ config, lib, inputs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types findSingle;
  cfg = config.modules.desktop.hyprland;
in
{
  imports = [ inputs.desktop-flake.nixosModules.default ];

  options.modules.desktop.hyprland = {
    enable = mkEnableOption "Whether to enable Hyprland";
    xdg-autostart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to autostart programs that ask for it";
    };
  };

  config = mkIf cfg.enable (mkMerge [{
    modules.desktop.tiling-wm = {
      enable = true;
      wayland = {
        enable = true;
        swww.enable = true;
      };
    };

    desktop-flake.enable = true;
    hm.imports = [ inputs.desktop-flake.homeManagerModules.default ];
    hm.desktop-flake = {
      enable = true;
      nvidia = config.modules.system.nvidia.enable;
      primaryMonitor = (findSingle (m: m.primary) "DP-1" "DP-1"
        config.modules.devices.monitors).name;
      hyprland = {
        additionalSessionVariables =
          config.modules.desktop.tiling-wm.wayland.sessionVariables;
        gaps = {
          inner = 5;
          outer = 4;
          workspaces = 50;
        };
        rounding = 10;
        tearing.enable = config.modules.gaming.enable;
        xdg-autostart = cfg.xdg-autostart;
      };
      hyprlock.enable = false;
    };

    modules.system.persist.cache.home.directories = [
      ".cache/ags/user"
    ];
  }]);
}
