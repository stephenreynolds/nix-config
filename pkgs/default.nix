{ pkgs ? (import ../nixpkgs.nix) { } }:
{
  qt6gtk2 = pkgs.qt6Packages.callPackage ./qt6gtk2 { };

  primary-xwayland = pkgs.callPackage ./primary-xwayland { };

  sway-audio-idle-inhibit = pkgs.callPackage ./sway-audio-idle-inhibit { };

  t = pkgs.callPackage ./t { };
  tt = pkgs.callPackage ./tt { };

  json-notification-daemon = pkgs.callPackage ./json-notification-daemon { };

  segoe-fluent-icons = pkgs.callPackage ./segoe-fluent-icons { };
}
