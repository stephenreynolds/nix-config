{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
in
lib.mkIf cfg.enable {
  hm.windowManager.hyprland.windowRules = let 
    rule = rules: attrs: attrs // { inherit rules; };

    ags.class = [ "com.github.Aylur.ags" ];
    bluetoothManager.class = [ ".blueman-manager-wrapped" ];
    firefoxModal = {
      class = [ "firefox" ];
      title = [ "Extension.+Mozilla Firefox.*" "Picture-in-Picture" ];
    };
    gnomeCalculator.class = [ "org.gnome.Calculator" ];
    gnomeClocks.class = [ "org.gnome.clocks" ];
    mpv.class = [ "mpv" ];
    onedrivegui.title = [ "OneDriveGUI" ];
    pavucontrol.class = [ "pavucontrol" ];
    piavpn.class = [ "piavpn" ];
    polkitAgent.class = [
      "lxqt-policykit-agent"
      "polkit-gnome-authentication-agent-1"
      "polkit-mate-authentication-agent-1"
    ];
    riichiCity.class = [ "Mahjong-JP.x86_64" ];
    steam.class = [ "steam" ];
    steamApp.class = [ "steam_app_.*" ];
    steamModal = {
      class = steam.class;
      title = [
        "Steam Settings"
        "Friends List"
      ];
    };
    tastytrade.class = [ "tasty.javafx.launcher.LauncherFxApp" ];
    xdgPortal.class = [
      "xdg-desktop-portal.*"
      "org.freedesktop.impl.portal.desktop.kde"
    ];
  in lib.concatLists [
    [
      (rule [ "size 600 600" ] pavucontrol)
      (rule [ "move 78% 22%" ] onedrivegui)
    ]

    (map (rule [ "float" ]) [
      ags
      bluetoothManager
      gnomeCalculator
      gnomeClocks
      onedrivegui
      steamModal
      xdgPortal
    ])

    (map (rule [ "nofullscreenrequest"]) [
      piavpn
      steam
      tastytrade
    ])

    (map (rule [ "float" "center" ]) [
      pavucontrol
      polkitAgent
    ])

    (map (rule [ "float" "pin" "noborder" "noshadow" ]) [
      firefoxModal
    ])

    (map (rule [ "fullscreen" ]) [
      steamApp
    ])

    (map (rule [ "keepaspectratio" ]) [
      mpv
      steamApp
      riichiCity
    ])
  ];
}
