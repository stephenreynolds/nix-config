{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
  configPath = "${cfg.configPath}/40-workspaces.conf";

  primaryMonitor =
    lib.findSingle (m: m.primary) "DP-1" "DP-1" config.modules.devices.monitors;
  terminal = config.hm.home.sessionVariables.TERMINAL;
in
lib.mkIf cfg.enable {
  hm.home.file."${configPath}".text = ''
    workspace = special, monitor:${primaryMonitor.name}, on-created-empty:[group new] ${terminal}
  '';
}
