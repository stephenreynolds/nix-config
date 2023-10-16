{ pkgs, ... }:
{
  imports = [
    ./lutris.nix
    ./proton.nix
    ./steam.nix
    ./yuzu.nix
  ];

  home.packages = with pkgs; [
    gamescope
    mangohud
  ];
}
