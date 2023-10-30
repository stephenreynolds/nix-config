{ config, lib, ... }:
with lib;
let cfg = config.modules.shell.btop;
in {
  options.modules.shell.btop = {
    enable = mkEnableOption "Enable btop";
    theme = {
      theme = mkOption {
        type = types.str;
        default = "TTY";
        description = "Color theme to use";
      };
      background = mkOption {
        type = types.bool;
        default = false;
        description = "Use background color";
      };
    };
  };

  config = mkIf cfg.enable {
    hm.programs.btop = {
      enable = true;
      settings = {
        color_theme = cfg.theme.theme;
        theme_background = cfg.theme.background;
      };
    };
  };
}
