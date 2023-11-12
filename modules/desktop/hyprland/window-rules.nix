{ config, lib, ... }:
with lib;
let
  cfg = config.modules.desktop.hyprland;
  configPath = "${cfg.configPath}/50-window-rules.conf";
in
mkIf cfg.enable {
  hm.home.file."${configPath}".text = ''
    # ags
    windowrule = float, ^(com.github.Aylur.ags)$

    # XDG Portal
    windowrule = float, ^(xdg-desktop-portal.*)$

    # wofi
    windowrule = dimaround, ^(wofi)$

    # TastyTrade
    windowrule = nofullscreenrequest, ^(tasty.javafx.launcher.LauncherFxApp)$

    # Steam
    windowrulev2 = nofullscreenrequest, class:^(steam)$
    windowrulev2 = maximize, class:^(steam)$
    windowrulev2 = float, title:^(Steam Settings)$
    windowrulev2 = float, title:^(Friends List)$, class:^(steam)$

    # ElectronMail
    windowrulev2 = maximize, class:^(electron-mail)$

    # Discord
    windowrulev2 = maximize, class:^(discord)$

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
    windowrulev2 = float,class:^(pavucontrol.*)$
    windowrulev2 = center,class:^(pavucontrol.*)$

    # Bluetooth Manager
    windowrulev2 = float, class:^(.blueman-manager-wrapped)$

    # GNOME Clocks
    windowrulev2 = float, class:^(org.gnome.clocks)$

    # GNOME Calculator
    windowrulev2 = float, class:^(org.gnome.Calculator)$

    # mpv
    windowrulev2 = keepaspectratio, class:^(mpv)$

    # piavpn
    windowrulev2 = nofullscreenrequest,class:^(piavpn)$

    # onedrivegui
    windowrulev2 = float, title:^(OneDriveGUI)$
    windowrulev2 = move 78% 22%, title:^(OneDriveGUI)$

    # Games
    ## Riichi City
    windowrulev2 = keepaspectratio, class:^(Mahjong-JP.x86_64)$
    ## Steam games
    windowrulev2 = keepaspectratio, class:^(steam_app_.*)$
    windowrulev2 = keepaspectratio, class:^(steam_app_.*)$
    windowrulev2 = fullscreen, class:^(steam_app_.*)$
  '';
}
