{ config, lib, inputs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.modules.cli.nvim;
in {
  options.modules.cli.nvim = {
    enable = mkEnableOption "Enable Neovim";
    defaultEditor = mkEnableOption "Set Neovim as default editor";
    viAlias = mkOption {
      type = types.bool;
      default = true;
      description = "Create vi alias";
    };
    vimAlias = mkOption {
      type = types.bool;
      default = true;
      description = "Create vim alias";
    };
    vimdiffAlias = mkOption {
      type = types.bool;
      default = true;
      description = "Create vimdiff alias";
    };
  };

  config = mkIf cfg.enable {
    hm.imports = [ inputs.nvim-config.homeManagerModules.default ];

    hm.programs.neovim = {
      enable = true;
      defaultEditor = cfg.defaultEditor;
      viAlias = cfg.viAlias;
      vimAlias = cfg.vimAlias;
      vimdiffAlias = cfg.vimdiffAlias;
    };

    modules.system.persist.state.home.directories =
      [ ".local/share/nvim" ".config/github-copilot" ];
  };
}
