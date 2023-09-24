{ pkgs, ... }:
{
  imports = [ ../common ];

  home.packages = with pkgs; [
    blackbox-terminal
    amberol
    fragments
  ];
}
