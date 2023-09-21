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
    inputs.ags.packages.${pkgs.system}.default
    sassc
    inotify-tools
    wf-recorder
    swww
    swappy
    slurp
    imagemagick
    inter
  ];
}
