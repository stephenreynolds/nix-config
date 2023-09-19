{ config, lib, ... }:
let
  primaryMonitor = lib.findSingle (m: m.primary) "DP-1" "DP-1" config.monitors;
  terminal = config.home.sessionVariables.TERMINAL;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = hyprctl dispatch focusmonitor ${primaryMonitor.name}
    exec-once = [workspace special silent] ${terminal}
  '';
}
