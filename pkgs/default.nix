{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # Packages with a source
  qt6gtk2 = pkgs.qt6Packages.callPackage ./qt6gtk2.nix { };
  primary-xwayland = pkgs.callPackage ./primary-xwayland.nix { };
  apple-fonts = pkgs.callPackage ./apple-fonts.nix { };
  tastytrade = pkgs.callPackage ./tastytrade.nix { };

  # Custom packages
  sway-audio-idle-inhibit = pkgs.callPackage ./sway-audio-idle-inhibit.nix { };
  t = pkgs.callPackage ./t { };
  tt = pkgs.callPackage ./tt { };
  allusion = pkgs.callPackage ./allusion.nix { };
  segoe-fluent-icons = pkgs.callPackage ./segoe-fluent-icons.nix { };
  ttf-ms-win11-auto = pkgs.callPackage ./ttf-ms-win11-auto.nix { };
}
