{ config, lib, inputs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types findSingle;
  cfg = config.modules.desktop.hyprland;
in {
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
      xdg-autostart = cfg.xdg-autostart;
      primaryMonitor = (findSingle (m: m.primary) "DP-1" "DP-1"
        config.modules.devices.monitors).name;
      hypridle.suspend.enable = false;
    };

    modules.system.persist.cache.home.directories = [ ".cache/ags/user" ];
  }]);
}
