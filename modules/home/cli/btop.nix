{ config, lib, ... }:

let cfg = config.my.cli.btop;
in {
  options.my.cli.btop = {
    enable = lib.mkEnableOption "Enable btop";
    theme = {
      theme = lib.mkOption {
        type = lib.types.str;
        default = "TTY";
        description = "Color theme to use";
      };
      background = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use background color";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = cfg.theme.theme;
        theme_background = cfg.theme.background;
      };
    };
  };
}
