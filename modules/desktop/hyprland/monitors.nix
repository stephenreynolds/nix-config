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
        bitdepth =
          if m.bitdepth == null then
            ""
          else ", bitdepth, ${builtins.toString m.bitdepth}";
        vrr =
          if m.vrr == 0 then
            ""
          else ", vrr, ${builtins.toString m.vrr}";
      in
      "${m.name}, ${
          if m.enabled then "${resolution}, ${position}, ${scaling}, transform, ${transform}${bitdepth}${vrr}" else "disable"
          }")
    config.modules.devices.monitors;
}
