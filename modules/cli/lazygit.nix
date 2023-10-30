{ config, lib, ... }:
with lib;
let cfg = config.modules.cli.lazygit;
in {
  options.modules.cli.lazygit = {
    enable = mkEnableOption "Enable LazyGit";
    colors = {
      activeBorderColor = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Active border color";
      };
      inactiveBorderColor = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Inactive border color";
      };
      optionsTextColor = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Options text color";
      };
      selectedLineBgColor = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Selected line bg color";
      };
      selectedRangeBgColor = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Selected range bg color";
      };
      cherryPickedCommitBgColor = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Cherry-picked commit bg color";
      };
      cherryPickedCommitFgColor = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Cherry-picked commit fg color";
      };
      unstagedChangesColor = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Unstaged changes color";
      };
    };
  };

  config = mkIf cfg.enable {
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
      };
    };
  };
}
