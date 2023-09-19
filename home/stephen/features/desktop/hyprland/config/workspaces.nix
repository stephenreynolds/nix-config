{ lib, config, ... }:
let
  primaryMonitor = lib.findSingle (m: m.primary) "DP-1" "DP-1" config.monitors;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    workspace = special, monitor:${primaryMonitor.name}
  '';
}
