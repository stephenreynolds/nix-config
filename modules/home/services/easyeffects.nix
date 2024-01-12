{ config, lib, ... }:

let
  inherit (lib) types mkOption mkEnableOption mkIf;
  cfg = config.my.services.easyeffects;
in
{
  options.my.services.easyeffects = {
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
    services.easyeffects = {
      enable = true;
      preset = mkIf cfg.preset.enable "Preset";
    };

    xdg.configFile."Preset.json" = {
      enable = cfg.preset.enable;
      source = cfg.preset.source;
      target = "easyeffects/output/Preset.json";
    };

    xdg.configFile."autoload.json" = {
      enable = cfg.autoload.enable;
      source = cfg.autoload.source;
      target = "easyeffects/autoload/output/autoload.json";
    };
  };
}
