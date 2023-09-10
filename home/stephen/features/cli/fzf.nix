{ config, ... }:
let
  inherit (config.colorscheme) colors;
in
{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    colors = {
      "bg+" = "#${colors.base02}";
      bg = "#${colors.base00}";
      spinner = "#${colors.base06}";
      hl = "#${colors.base08}";
      fg = "#${colors.base05}";
      header = "#${colors.base08}";
      info = "#${colors.base0E}";
      pointer = "#${colors.base06}";
      marker = "#${colors.base06}";
      "fg+" = "#${colors.base05}";
      prompt = "#${colors.base0E}";
      "hl+" = "#${colors.base08}";
    };
    defaultCommand = "ag --ignore .git -g ''";
    defaultOptions = [ "--extended" ];
    fileWidgetCommand = "ag --hidden --ignore .git -g '' --ignore '.cache' --ignore '.dotfiles' --ignore '.local' --ignore '.mozilla'";
  };
}
