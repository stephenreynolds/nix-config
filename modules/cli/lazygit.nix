{ config, lib, ... }:

let
  cfg = config.modules.cli.lazygit;
  colorscheme = config.modules.desktop.theme.colorscheme;
in {
  options.modules.cli.lazygit = {
    enable = lib.mkEnableOption "Enable LazyGit";
    colors = {
      activeBorderColor = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = if colorscheme != null then [
          "#${colorscheme.palette.base0B}"
          "bold"
        ] else
          [ ];
        description = "Active border color";
      };
      inactiveBorderColor = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = if colorscheme != null then
          [ "#${colorscheme.palette.base05}" ]
        else
          [ ];
        description = "Inactive border color";
      };
      optionsTextColor = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = if colorscheme != null then
          [ "#${colorscheme.palette.base0D}" ]
        else
          [ ];
        description = "Options text color";
      };
      selectedLineBgColor = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = if colorscheme != null then
          [ "#${colorscheme.palette.base02}" ]
        else
          [ ];
        description = "Selected line bg color";
      };
      selectedRangeBgColor = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = if colorscheme != null then
          [ "#${colorscheme.palette.base02}" ]
        else
          [ ];
        description = "Selected range bg color";
      };
      cherryPickedCommitBgColor = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = if colorscheme != null then
          [ "#${colorscheme.palette.base0C}" ]
        else
          [ ];
        description = "Cherry-picked commit bg color";
      };
      cherryPickedCommitFgColor = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = if colorscheme != null then
          [ "#${colorscheme.palette.base0D}" ]
        else
          [ ];
        description = "Cherry-picked commit fg color";
      };
      unstagedChangesColor = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = if colorscheme != null then
          [ "#${colorscheme.palette.base08}" ]
        else
          [ ];
        description = "Unstaged changes color";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hm.programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          showRandomTip = false;
          nerdFontsVersion = "3";
          theme = {
            lightTheme = false;
            activeBorderColor = cfg.colors.activeBorderColor;
            inactiveBorderColor = cfg.colors.inactiveBorderColor;
            optionsTextColor = cfg.colors.optionsTextColor;
            selectedLineBgColor = cfg.colors.selectedLineBgColor;
            selectedRangeBgColor = cfg.colors.selectedLineBgColor;
            cherryPickedCommitBgColor = cfg.colors.cherryPickedCommitBgColor;
            cherryPickedCommitFgColor = cfg.colors.cherryPickedCommitFgColor;
            unstagedChangesColor = cfg.colors.unstagedChangesColor;
          };
        };
        git.overrideGpg = true;
      };
    };

    modules.system.persist.state.home.files = [ ".config/lazygit/state.yml" ];
  };
}
