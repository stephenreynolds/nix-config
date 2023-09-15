{
  wayland.windowManager.hyprland.extraConfig = ''
    windowrule = dimaround, ^(wofi)$
    windowrule = nofullscreenrequest, ^(steam)$
    windowrule = nofullscreenrequest, ^(tasty.javafx.launcher.LauncherFxApp)$

    ## Rules: polkit agent
    windowrulev2 = float,class:^(lxqt-policykit-agent)$
    windowrulev2 = center,class:^(lxqt-policykit-agent)$
    windowrulev2 = float,class:^(polkit-gnome-authentication-agent-1)$
    windowrulev2 = center,class:^(polkit-gnome-authentication-agent-1)$
    windowrulev2 = float,class:^(polkit-mate-authentication-agent-1)$
    windowrulev2 = center,class:^(polkit-mate-authentication-agent-1)$

    ## Rules: browser
    windowrulev2 = idleinhibit fullscreen,class:^(Chromium-browser)$
    windowrulev2 = idleinhibit fullscreen,class:^(Brave-browser)$
    windowrulev2 = idleinhibit fullscreen,class:^(firefox)$
    windowrulev2 = idleinhibit fullscreen,class:^(microsoft-edge)$
    windowrulev2 = float,title:^(Firefox - Sharing Indicator)$

    ## Rules: picture-in-picture
    windowrulev2 = float,title:^(Picture-in-Picture)$
    windowrulev2 = pin,title:^(Picture-in-Picture)$
    windowrulev2 = noborder,title:^(Picture-in-Picture)$
    windowrulev2 = noshadow,title:^(Picture-in-Picture)$

    ## Rules: pavucontrol
    windowrulev2 = float,class:^(pavucontrol)$
    windowrulev2 = center,class:^(pavucontrol)$
    windowrulev2 = float,class:^(pavucontrol-qt)$
    windowrulev2 = center,class:^(pavucontrol-qt)$

    ## Rules: piavpn
    windowrulev2 = nofullscreenrequest,class:^(piavpn)$

    ## Rules: onedrivegui
    windowrulev2 = float, title:^(OneDriveGUI)$
    windowrulev2 = move 78% 22%, title:^(OneDriveGUI)$
  '';
}
