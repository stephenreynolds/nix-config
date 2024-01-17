{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;

  compileLayerRulePatterns = rule:
    rule // {
      namespace = "^(${lib.concatStringsSep "|" rule.namespace})";
    };

  expandRuleToList = rule2:
    let rule1 = removeAttrs rule2 [ "rules" ];
    in map (rule: rule1 // { inherit rule; }) rule2.rules;

  layerRuleToString = rule: "${rule.rule}, ${rule.namespace}";

  mapLayerRules = rules: lib.pipe rules [
    (map compileLayerRulePatterns)
    (map expandRuleToList)
    lib.concatLists
    (map layerRuleToString)
  ];

  rule = rules: namespace: { inherit rules namespace; };
in
lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.settings.layerrule =
    let
      overview = [ "overview" ];
    in
    mapLayerRules (lib.concatLists [
      [
        (rule [ "noanim" "xray on" ] overview)
      ]
    ]);
}
