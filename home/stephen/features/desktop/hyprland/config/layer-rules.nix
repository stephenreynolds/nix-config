{
  wayland.windowManager.hyprland.extraConfig = ''
    layerrule = blur, notifications
    layerrule = ignorezero, notifications

    layerrule = blur, rofi
    layerrule = ignorezero, rofi

    layerrule = blur, gtk-layer-shell
    layerrule = ignorezero, gtk-layer-shell

    layerrule = blur, eww
    layerrule = ignorezero, eww

    layerrule = blur, ^(bar-.)$
    layerrule = ignorezero, ^(bar-.)$
  '';
}
