{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mailspring
  ];
}
