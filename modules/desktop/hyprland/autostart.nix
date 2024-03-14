{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;

  primaryMonitor =
    lib.findSingle (m: m.primary) "DP-1" "DP-1" config.modules.devices.monitors;
in lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.settings = {
    "exec-once" = [ "hyprctl dispatch focusmonitor ${primaryMonitor.name}" ];
  };
}
