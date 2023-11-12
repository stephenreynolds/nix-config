{ config, lib, ... }:
with lib;
let
  cfg = config.modules.desktop.hyprland;
  configPath = "${cfg.configPath}/60-layer-rules.conf";
in
mkIf cfg.enable {
  hm.home.file."${configPath}".text = ''
    layerrule = blur, notifications
    layerrule = ignorezero, notifications

    layerrule = blur, rofi
    layerrule = ignorezero, rofi

    layerrule = blur, gtk-layer-shell
    layerrule = ignorezero, gtk-layer-shell

    layerrule = blur, ^(bar-.)$
    layerrule = ignorezero, ^(bar-.)$
    layerrule = blur, ^(notifications-.)$
    layerrule = ignorezero, ^(notifications-.)$
  '';
}
