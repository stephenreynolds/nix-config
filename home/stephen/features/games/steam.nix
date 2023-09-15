{ lib, pkgs, ... }:
let
  steam-with-pkgs = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib
      libkrb5
      keyutils
    ];
  };

  extraCompatPackages = with pkgs; [
    proton-ge
  ];
in
{
  home.packages = [
    steam-with-pkgs
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = lib.makeBinPath extraCompatPackages;
  };
}
