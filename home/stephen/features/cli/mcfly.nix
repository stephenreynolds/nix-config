{ config, ... }:
{
  programs.mcfly = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;
    keyScheme = "vim";
    fuzzySearchFactor = 2;
  };
}
