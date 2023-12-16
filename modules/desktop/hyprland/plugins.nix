{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.modules.desktop.hyprland;

  hyprland-plugins = inputs.hyprland-plugins.packages.${pkgs.system};
in
lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.plugins = [
    hyprland-plugins.hyprwinwrap  
  ];

  hm.wayland.windowManager.hyprland.settings = {
    plugin = {
      hyprwinwrap = {
        class = "kitty-bg";
      };
    };
  };
}
