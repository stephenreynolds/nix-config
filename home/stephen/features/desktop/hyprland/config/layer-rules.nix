{
  wayland.windowManager.hyprland.extraConfig = ''
    blurls = notifications
    layerrule = ignorezero, notifications
    blurls = rofi
    layerrule = ignorezero, rofi
    blurls = gtk-layer-shell
    layerrule = ignorezero, gtk-layer-shell
    blurls = eww
    layerrule = ignorezero, eww
  '';
}
