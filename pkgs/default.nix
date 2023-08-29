{ pkgs ? (import ../nixpkgs.nix) { } }:
{
  qt6gtk2 = pkgs.qt6Packages.callPackage ./qt6gtk2 { };

  primary-xwayland = pkgs.callPackage ./primary-xwayland { };

  sway-audio-idle-inhibit = pkgs.callPackage ./sway-audio-idle-inhibit { };

  preload = pkgs.callPackage ./preload { };

  t = pkgs.callPackage ./t { };
  tt = pkgs.callPackage ./tt { };
}
