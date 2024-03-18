{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.cli.lazygit;
in {
  options.modules.cli.lazygit = { enable = mkEnableOption "Enable LazyGit"; };

  config = mkIf cfg.enable {
    hm.programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          showRandomTip = false;
          nerdFontsVersion = "3";
        };
        git.overrideGpg = true;
      };
    };

    modules.system.persist.state.home.files = [ ".config/lazygit/state.yml" ];
  };
}
