{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.cli.shell.zsh;
in {
  options.modules.cli.shell.zsh = {
    enable = mkEnableOption "Whether to enable zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;

    hm.programs.zsh = {
      enable = true;
      enableVteIntegration = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
