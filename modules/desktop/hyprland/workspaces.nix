{ config, lib, ... }:
let
  primaryMonitor =
    lib.findSingle (m: m.primary) "DP-1" "DP-1" config.modules.devices.monitors;
  terminal = config.hm.home.sessionVariables.TERMINAL;
in
lib.mkIf config.modules.desktop.hyprland.enable {
  hm.wayland.windowManager.hyprland.extraConfig = ''
    workspace = special, monitor:${primaryMonitor.name}, on-created-empty:[group new] ${terminal}
  '';
}
