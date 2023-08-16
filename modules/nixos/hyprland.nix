{ inputs, pkgs, ... }:
{
  imports = [ inputs.hyprland.nixosModules.default ];

  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
