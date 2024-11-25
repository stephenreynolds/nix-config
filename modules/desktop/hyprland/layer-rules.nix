{ config, lib, ... }:

let
  inherit (lib) mkIf concatStringsSep concatLists pipe;
  cfg = config.modules.desktop.hyprland;

  compileLayerRulePatterns = rule:
    rule // {
      namespace = "^(${concatStringsSep "|" rule.namespace})";
    };

  expandRuleToList = rule2:
    let rule1 = removeAttrs rule2 [ "rules" ];
    in map (rule: rule1 // { inherit rule; }) rule2.rules;

  layerRuleToString = rule: "${rule.rule}, ${rule.namespace}";

  mapLayerRules = rules:
    pipe rules [
      (map compileLayerRulePatterns)
      (map expandRuleToList)
      concatLists
      (map layerRuleToString)
    ];

  rule = rules: namespace: { inherit rules namespace; };
in
mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.settings.layerrule =
    let
      clock = [ "shell-clock" ];
      hyprpicker = [ "hyprpicker" ];
      selection = [ "selection" ];
      avizo = [ "avizo" ];
    in
    mapLayerRules [
      (rule [ "noanim" ] clock)
      (rule [ "blur" "ignorealpha 0.65" "xray on" "noanim" ] avizo)
      (rule [ "animation fade" ] hyprpicker)
      (rule [ "animation fade" ] selection)
    ];
}
