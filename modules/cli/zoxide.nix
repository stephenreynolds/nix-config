{ config, lib, ... }:
with lib;
let cfg = config.modules.cli.zoxide;
in {
  options.modules.cli.zoxide = { enable = mkEnableOption "Enable zoxide"; };

  config = mkIf cfg.enable {
    hm.programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = config.modules.cli.shell.fish.enable;
      # TODO: Configure using flake config
      enableZshIntegration = config.programs.zsh.enable;
    };
  };
}
