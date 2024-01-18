{ config, lib, inputs, ... }:

let cfg = config.modules.cli.nvim;
in {
  options.modules.cli.nvim = {
    enable = lib.mkEnableOption "Enable Neovim";
    defaultEditor = lib.mkEnableOption "Set Neovim as default editor";
    viAlias = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Create vi alias";
    };
    vimAlias = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Create vim alias";
    };
    vimdiffAlias = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Create vimdiff alias";
    };
  };

  config = lib.mkIf cfg.enable {
    hm.imports = [
      inputs.nvim-config.homeManagerModules.default
    ];

    hm.programs.neovim = {
      enable = true;
      defaultEditor = cfg.defaultEditor;
      viAlias = cfg.viAlias;
      vimAlias = cfg.vimAlias;
      vimdiffAlias = cfg.vimdiffAlias;
    };

    modules.system.persist.state.home.directories = [ ".local/share/nvim" ];
  };
}
