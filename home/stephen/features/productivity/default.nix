{ pkgs, ... }:
{
  imports = [
    ./latex.nix
    ./obsidian.nix
    ./thunderbird.nix
  ];

  home.packages = with pkgs; [
    allusion
    gimp-with-plugins
    krita
  ];
}
