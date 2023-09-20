{ inputs, pkgs, ... }:
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    configDir = inputs.ags-config.configDir;
  };

  home.packages = with pkgs; [
    sassc
    inotify-tools
  ];
}
