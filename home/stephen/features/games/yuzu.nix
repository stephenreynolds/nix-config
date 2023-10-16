{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yuzu-mainline
  ];
}
