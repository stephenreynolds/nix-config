{
  wayland.windowManager.hyprland.extraConfig = ''
    # ags
    windowrule = float, ^(ags)$

    # XDG Portal
    windowrule = float, ^(xdg-desktop-portal)$
    windowrule = float, ^(xdg-desktop-portal-gnome)$

    # wofi
    windowrule = dimaround, ^(wofi)$

    # TastyTrade
    windowrule = workspace empty, ^(tasty.javafx.launcher.LauncherFxApp)$
    windowrule = nofullscreenrequest, ^(tasty.javafx.launcher.LauncherFxApp)$

    # Steam
    windowrule = workspace empty, ^(Mailspring)$

    # Steam
    windowrule = workspace empty, ^(steam)$
    windowrule = nofullscreenrequest, ^(steam)$

    # polkit agent
    windowrulev2 = float,class:^(lxqt-policykit-agent)$
    windowrulev2 = center,class:^(lxqt-policykit-agent)$
    windowrulev2 = float,class:^(polkit-gnome-authentication-agent-1)$
    windowrulev2 = center,class:^(polkit-gnome-authentication-agent-1)$
    windowrulev2 = float,class:^(polkit-mate-authentication-agent-1)$
    windowrulev2 = center,class:^(polkit-mate-authentication-agent-1)$

    # browser
    windowrulev2 = idleinhibit fullscreen,class:^(Chromium-browser)$
    windowrulev2 = idleinhibit fullscreen,class:^(Brave-browser)$
    windowrulev2 = idleinhibit fullscreen,class:^(firefox)$
    windowrulev2 = idleinhibit fullscreen,class:^(microsoft-edge)$
    windowrulev2 = float,title:^(Firefox - Sharing Indicator)$

    # picture-in-picture
    windowrulev2 = float,title:^(Picture-in-Picture)$
    windowrulev2 = pin,title:^(Picture-in-Picture)$
    windowrulev2 = noborder,title:^(Picture-in-Picture)$
    windowrulev2 = noshadow,title:^(Picture-in-Picture)$

    # pavucontrol
    windowrulev2 = float,class:^(pavucontrol)$
    windowrulev2 = center,class:^(pavucontrol)$
    windowrulev2 = float,class:^(pavucontrol-qt)$
    windowrulev2 = center,class:^(pavucontrol-qt)$

    # piavpn
    windowrulev2 = nofullscreenrequest,class:^(piavpn)$

    # onedrivegui
    windowrulev2 = float, title:^(OneDriveGUI)$
    windowrulev2 = move 78% 22%, title:^(OneDriveGUI)$
  '';
}
