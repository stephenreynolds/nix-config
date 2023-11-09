{ config, lib, pkgs, inputs, ... }:
with lib;
let
  primaryMonitor = lib.findSingle (m: m.primary) "DP-1" "DP-1" config.modules.devices.monitors;
  ags = "${inputs.ags.packages.${pkgs.system}.default}/bin/ags";
in mkIf config.modules.desktop.hyprland.enable {
  hm.wayland.windowManager.hyprland.extraConfig = ''
    exec = ${ags} -q; sleep 0.5; ${ags}
    exec-once = hyprctl dispatch focusmonitor ${primaryMonitor.name}
  '';
}
