{ lib, config, ... }:
let
  monitors = map (m: let
    resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
    position = "${toString m.x}x${toString m.y}";
  in
    "monitor = ${m.name}, ${if m.enabled then "${resolution}, ${position}, 1" else "disable"}"
  ) config.monitors;
in
{
  wayland.windowManager.hyprland.extraConfig = lib.concatLines monitors;
}
