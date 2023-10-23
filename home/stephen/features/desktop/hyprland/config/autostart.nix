{ config, lib, pkgs, inputs, ... }:
let
  primaryMonitor = lib.findSingle (m: m.primary) "DP-1" "DP-1" config.monitors;
  ags = "${inputs.ags.packages.${pkgs.system}.default}/bin/ags";
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    exec = ${ags} -q; sleep 0.5; ${ags}
    exec-once = hyprctl dispatch focusmonitor ${primaryMonitor.name}
  '';
}
