{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eww
    socat
  ];
}
