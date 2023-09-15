{ config, ... }:
let
  terminal = config.home.sessionVariables.TERMINAL;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = [workspace special silent] ${terminal}
  '';
}
