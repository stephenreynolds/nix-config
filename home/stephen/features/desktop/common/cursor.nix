{ pkgs, ... }:
{
  home.pointerCursor = {
    package = pkgs.apple-cursor;
    name = "macOS-BigSur-White";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
