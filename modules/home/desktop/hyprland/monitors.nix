{ config, lib, ... }:

let
  cfg = config.my.desktop.hyprland;
in
lib.mkIf cfg.enable {
  wayland.windowManager.hyprland.settings.monitor = map
    (m:
      let
        resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
        position = "${toString m.x}x${toString m.y}";
      in
      "${m.name}, ${if m.enabled then "${resolution}, ${position}, 1" else "disable"}")
    config.my.devices.monitors;
}
