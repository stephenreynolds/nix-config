{ config, lib, ... }:

let
  cfg = config.my.desktop.hyprland;

  primaryMonitor = lib.findSingle (m: m.primary) "DP-1" "DP-1" config.my.devices.monitors;
  ags = "${config.programs.ags.package}/bin/ags -b hyprland";
in
lib.mkIf cfg.enable {
  wayland.windowManager.hyprland.settings = {
    exec = [
      "${ags} -q; ${ags}"
    ];

    "exec-once" = [
      "hyprctl dispatch focusmonitor ${primaryMonitor.name}"
    ];
  };
}
