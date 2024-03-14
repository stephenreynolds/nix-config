{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;

  primaryMonitor =
    lib.findSingle (m: m.primary) "DP-1" "DP-1" config.modules.devices.monitors;
  terminal = config.hm.home.sessionVariables.TERMINAL;
in lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.settings.workspace = [
    "special, monitor:${primaryMonitor.name}, on-created-empty:[group new] ${terminal}"
  ];
}
