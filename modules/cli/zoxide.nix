{ config, lib, ... }:

let cfg = config.modules.cli.zoxide;
in {
  options.modules.cli.zoxide = { enable = lib.mkEnableOption "Enable zoxide"; };

  config = lib.mkIf cfg.enable {
    hm.programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = config.modules.cli.shell.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };

    modules.system.persist.state.home.directories = [ ".local/share/zoxide" ];
  };
}
