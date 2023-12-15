{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
in
lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.config.workspace = let 
    primaryMonitor =
      lib.findSingle (m: m.primary) "DP-1" "DP-1" config.modules.devices.monitors;
    terminal = config.hm.home.sessionVariables.TERMINAL;
  in [
    "special, monitor:${primaryMonitor.name}, on-created-empty:[group new] ${terminal}"
  ];
}
