{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;

  compileWindowRulePatterns = rule:
    rule // {
      class = lib.mapNullable (x: "class:^(${lib.concatStringsSep "|" x})$")
        rule.class;
      title = lib.mapNullable (x: "title:^(${lib.concatStringsSep "|" x})$")
        rule.title;
    };

  expandRuleToList = rule2:
    let rule1 = removeAttrs rule2 [ "rules" ];
    in map (rule: rule1 // { inherit rule; }) rule2.rules;

  windowRuleToString = rule:
    lib.concatStringsSep ", " ([ rule.rule ]
      ++ (lib.optional (rule.class != null) rule.class)
      ++ (lib.optional (rule.title != null) rule.title));

  mapWindowRules = rules:
    lib.pipe rules [
      (map compileWindowRulePatterns)
      (map expandRuleToList)
      lib.concatLists
      (map windowRuleToString)
    ];

  rule = rules: { class ? null, title ? null }: { inherit rules class title; };
in
lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.settings.windowrulev2 =
    let
      bluetoothManager.class = [ ".blueman-manager-wrapped" ];
      firefoxModal = {
        class = [ "firefox" ];
        title = [ "Extension.+Mozilla Firefox.*" ];
      };
      pictureInPicture = {
        title = [ "Picture-in-Picture" ];
      };
      gnomeCalculator.class = [ "org.gnome.Calculator" ];
      gnomeClocks.class = [ "org.gnome.clocks" ];
      mpv.class = [ "mpv" ];
      onedrivegui.title = [ "OneDriveGUI" ];
      pavucontrol.class = [ "pavucontrol" ];
      piavpn.class = [ "piavpn" ];
      qalculate-gtk.class = [ "qalculate-gtk" ];
      mahjongsoul.class = [ "jantama_mahjongsoul.exe" ];
      riichiCity.class = [ "Mahjong-JP.x86_64" ];
      sioyek.class = [ "sioyek" ];
      steam.class = [ "steam" ];
      steamApp.class = [ "steam_app_.*" ];
      steamModal = {
        class = steam.class;
        title = [ "Steam Settings" "Friends List" "^((?!Steam).)*$" ];
      };
      tastytrade.class = [ "tasty.javafx.launcher.LauncherFxApp" ];
    in
    mapWindowRules (lib.concatLists [
      [
        (rule [ "size 600 600" ] pavucontrol)
        (rule [ "move 78% 22%" ] onedrivegui)
      ]

      (map (rule [ "float" ]) [
        bluetoothManager
        gnomeCalculator
        gnomeClocks
        onedrivegui
        qalculate-gtk
        steamModal
      ])

      (map (rule [ "suppressevent fullscreen" ]) [ piavpn steam tastytrade ])

      (map (rule [ "float" "center" ]) [ pavucontrol ])

      (map (rule [ "float" "pin" "noborder" "noshadow" ]) [ firefoxModal pictureInPicture ])

      (map (rule [ "keepaspectratio" ]) [ pictureInPicture ])

      (map (rule [ "fullscreen" "immediate" ]) [ steamApp ])

      (map (rule [ "keepaspectratio" ]) [ mpv steamApp riichiCity mahjongsoul ])

      (map (rule [ "renderunfocused" ]) [ steamApp riichiCity mahjongsoul ])

      (map (rule [ "opacity 0.8 override" ]) [ sioyek ])
    ]);
}
