{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;

  primaryMonitor = lib.findSingle (m: m.primary) "DP-1" "DP-1" config.modules.devices.monitors;
  ags = "${config.hm.programs.ags.package}/bin/ags -b hyprland";
in
lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.settings = {
    exec = [
      "${ags} -q; sleep 0.5; ${ags}"
    ];

    "exec-once" = [
      "hyprctl dispatch focusmonitor ${primaryMonitor.name}"
    ];
  };
}
