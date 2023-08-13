{ pkgs ? (import ../nixpkgs.nix) { } }: rec {
  qt6gtk2 = pkgs.qt6Packages.callPackage ./qt6gtk2 { };

  primary-xwayland = pkgs.callPackage ./primary-xwayland { };
  apple-fonts = pkgs.callPackage ./apple-fonts { };
}
