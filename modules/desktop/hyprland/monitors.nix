{ config, lib, ... }:
let
  monitors = map
    (m:
      let
        resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
        position = "${toString m.x}x${toString m.y}";
      in
      "monitor = ${m.name}, ${if m.enabled then "${resolution}, ${position}, 1" else "disable"}")
    config.modules.devices.monitors;
in
lib.mkIf config.modules.desktop.hyprland.enable {
  hm.wayland.windowManager.hyprland.extraConfig = lib.concatLines monitors;
}
