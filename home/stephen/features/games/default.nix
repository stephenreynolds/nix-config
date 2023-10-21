{ pkgs, ... }:
{
  imports = [
    ./lutris.nix
    ./osu.nix
    ./proton.nix
    ./steam.nix
    ./yuzu.nix
  ];

  home.packages = with pkgs; [
    mangohud
  ];
}
