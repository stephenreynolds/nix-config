{ config, lib, ... }:

let cfg = config.modules.services.easyeffects;
in {
  options.modules.services.easyeffects = {
    enable = lib.mkEnableOption "Enable EasyEffects";
    preset = {
      enable = lib.mkEnableOption "Enable preset";
      source = lib.mkOption {
        type = lib.types.path;
        default = null;
        description = "Path to the preset file";
      };
    };
    autoload = {
      enable = lib.mkEnableOption "Enable output autoload";
      source = lib.mkOption {
        type = lib.types.path;
        default = null;
        description = "Path to the autoload file";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hm.services.easyeffects = {
      enable = true;
      preset = lib.mkIf cfg.preset.enable "Preset";
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
