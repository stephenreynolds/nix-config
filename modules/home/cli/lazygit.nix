{ config, lib, ... }:

let
  cfg = config.my.cli.lazygit;
in
{
  options.my.cli.lazygit = {
    enable = lib.mkEnableOption "Enable LazyGit";
  };

  config = lib.mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          showRandomTip = false;
          nerdFontsVersion = "3";
        };
        git.overrideGpg = true;
      };
    };
  };
}
