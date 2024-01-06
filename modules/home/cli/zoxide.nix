{ config, lib, ... }:

let cfg = config.my.cli.zoxide;
in {
  options.my.cli.zoxide = {
    enable = lib.mkEnableOption "Whether to enable zoxide";
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };
  };
}
