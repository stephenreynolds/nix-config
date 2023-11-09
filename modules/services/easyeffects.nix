{ config, lib, ... }:
with lib;
let cfg = config.modules.services.easyeffects;
in {
  options.modules.services.easyeffects = {
    enable = mkEnableOption "Enable EasyEffects";
    preset = {
      enable = mkEnableOption "Enable preset";
      source = mkOption {
        type = types.path;
        default = null;
        description = "Path to the preset file";
      };
    };
    autoload = {
      enable = mkEnableOption "Enable output autoload";
      source = mkOption {
        type = types.path;
        default = null;
        description = "Path to the autoload file";
      };
    };
  };

  config = mkIf cfg.enable {
    hm.services.easyeffects = {
      enable = true;
      preset = mkIf cfg.preset.enable "Preset";
    };

    hm.xdg.configFile."Preset.json" = {
      enable = cfg.preset.enable;
      source = cfg.preset.source;
      target = "easyeffects/output/Preset.json";
    };

    hm.xdg.configFile."autoload.json" = {
      enable = cfg.autoload.enable;
      source = cfg.autoload.source;
      target = "easyeffects/autoload/output/autoload.json";
    };
  };
}
