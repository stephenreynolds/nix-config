{ lib, config, ... }:
let
  primaryMonitor = lib.findSingle (m: m.primary) "DP-1" "DP-1" config.monitors;
  terminal = config.home.sessionVariables.TERMINAL;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    workspace = special, monitor:${primaryMonitor.name}, on-created-empty:[group new] ${terminal}
  '';
}
