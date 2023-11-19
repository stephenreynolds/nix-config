{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
  configPath = "${cfg.configPath}/10-autostart.conf";

  primaryMonitor = lib.findSingle (m: m.primary) "DP-1" "DP-1" config.modules.devices.monitors;
  ags = "${config.hm.programs.ags.package}/bin/ags";
in
lib.mkIf cfg.enable {
  hm.home.file."${configPath}".text = ''
    exec = ${ags} -q; sleep 0.5; ${ags}
    exec-once = hyprctl dispatch focusmonitor ${primaryMonitor.name}
  '';
}
