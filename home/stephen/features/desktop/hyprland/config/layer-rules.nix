{
  wayland.windowManager.hyprland.extraConfig = ''
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
