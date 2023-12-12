{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
  configPath = "${cfg.configPath}/60-layer-rules.conf";
in
lib.mkIf cfg.enable {
  hm.home.file."${configPath}".text = ''
    layerrule = blur, gtk-layer-shell
    layerrule = ignorezero, gtk-layer-shell

    layerrule = blur, ^(notifications-.*)$
    layerrule = ignorezero, ^(notifications-.*)$
    layerrule = ignorealpha 0.69, ^(notifications-.*)$
    layerrule = blur, ^(indicator-.*)$
    layerrule = ignorezero, ^(indicator-.*)$
    layerrule = ignorealpha 0.69, ^(indicator-.*)$
    layerrule = blur, ^(overview)$
    layerrule = xray 0, ^(overview)$
  '';
}
