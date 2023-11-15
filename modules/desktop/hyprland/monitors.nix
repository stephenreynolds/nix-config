{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
  configPath = "${cfg.configPath}/30-monitors.conf";
  monitors = map
    (m:
      let
        resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
        position = "${toString m.x}x${toString m.y}";
      in
      "monitor = ${m.name}, ${if m.enabled then "${resolution}, ${position}, 1" else "disable"}")
    config.modules.devices.monitors;
in
lib.mkIf cfg.enable {
  hm.home.file."${configPath}".text = lib.concatLines monitors;
}
