{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
  ];
}
