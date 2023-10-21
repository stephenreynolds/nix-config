{ config, pkgs, ... }:
let
  inherit (config.colorscheme) colors;
in
{
  programs.zellij = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;
    settings = {
      pane_frames = false;

      copy_command =
        if (builtins.elem pkgs.wl-clipboard config.home.packages) then
          "wl-copy"
        else
          "xclip-selection clipboard";

      themes = {
        base16 = {
          fg = "#${colors.base05}";
          bg = "#${colors.base02}";
          black = "#${colors.base00}";
          red = "#${colors.base08}";
          green = "#${colors.base0B}";
          yellow = "#${colors.base0A}";
          blue = "#${colors.base0D}";
          magenta = "#${colors.base0E}";
          cyan = "#${colors.base0C}";
          white = "#${colors.base07}";
          orange = "#${colors.base09}";
        };
      };

      theme = "base16";
    };
  };
}
