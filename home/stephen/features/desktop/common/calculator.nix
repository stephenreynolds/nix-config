{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnome.gnome-calculator
  ];
}
