{ config, ... }:
let
  inherit (config.colorscheme) colors;
in
{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showRandomTip = false;
        theme = {
          lightTheme = false;
          activeBorderColor = [ "#${colors.base0B}" "bold" ];
          inactiveBorderColor = [ "#${colors.base05}" ];
          optionsTextColor = [ "#${colors.base0D}" ];
          selectedLineBgColor = [ "#${colors.base02}" ];
          selectedRangeBgColor = [ "#${colors.base02}" ];
          cherryPickedCommitBgColor = [ "#${colors.base0C}" ];
          cherryPickedCommitFgColor = [ "#${colors.base0D}" ];
          unstagedChangesColor = [ "#${colors.base08}" ];
        };
      };
    };
  };
}
