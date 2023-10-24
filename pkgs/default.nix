{ pkgs ? (import ../nixpkgs.nix) { } }:
{
  # Packages with a source
  qt6gtk2 = pkgs.qt6Packages.callPackage ./qt6gtk2 { };
  primary-xwayland = pkgs.callPackage ./primary-xwayland { };
  apple-fonts = pkgs.callPackage ./apple-fonts { };

  # Custom packages
  sway-audio-idle-inhibit = pkgs.callPackage ./sway-audio-idle-inhibit { };
  t = pkgs.callPackage ./t { };
  tt = pkgs.callPackage ./tt { };
  allusion = pkgs.callPackage ./allusion { };
  segoe-fluent-icons = pkgs.callPackage ./segoe-fluent-icons { };
  ttf-ms-win11-auto = pkgs.callPackage ./ttf-ms-win11-auto { };
}
