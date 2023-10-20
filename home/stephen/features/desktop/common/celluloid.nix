{ pkgs, ... }:
{
  home.packages = with pkgs; [
    celluloid
  ];
}
