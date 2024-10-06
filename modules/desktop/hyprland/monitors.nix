{ config, lib, ... }:

let cfg = config.modules.desktop.hyprland;
in lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.settings.monitor = map
    (m:
      let
        resolution =
          if m.modeline == null then
            "${toString m.width}x${toString m.height}@${toString m.refreshRate}"
          else "modeline ${m.modeline}";
        position = "${toString m.x}x${toString m.y}";
        scaling = builtins.toString m.scaling;
        transform = builtins.toString m.transform;
      in
      "${m.name}, ${
      if m.enabled then "${resolution}, ${position}, ${scaling}, transform, ${transform}" else "disable"
    }")
    config.modules.devices.monitors;
}
