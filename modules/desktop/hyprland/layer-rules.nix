{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
in
lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.layerRules = [{
    namespace = [ ".*" ];
    rules = [ "xray 1" ];
  }];
}
