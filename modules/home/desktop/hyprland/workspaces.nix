{ config, lib, ... }:

let
  cfg = config.my.desktop.hyprland;

  primaryMonitor =
    lib.findSingle (m: m.primary) "DP-1" "DP-1" config.my.devices.monitors;
  terminal = config.home.sessionVariables.TERMINAL;
in
lib.mkIf cfg.enable {
  wayland.windowManager.hyprland.settings.workspace = [
    "special, monitor:${primaryMonitor.name}, on-created-empty:[group new] ${terminal}"
  ];
}
