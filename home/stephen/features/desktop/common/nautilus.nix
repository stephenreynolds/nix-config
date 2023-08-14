{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnome.nautilus
    gnome.sushi
    nautilus-open-any-terminal
  ];
}
