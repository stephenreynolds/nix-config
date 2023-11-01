{ inputs, pkgs, ... }:
{
  imports = [
    inputs.hyprland.nixosModules.default
    ./sddm.nix
  ];

  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
