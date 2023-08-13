{ config, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "${config.xdg.configHome}/btop/themes/catppuccin_mocha.theme";
      theme_background = false;
    };
  };
}
