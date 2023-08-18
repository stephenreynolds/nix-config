{ pkgs, lib, config, ... }:
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
      gamescope
      mangohud
    ];
  };

  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
in
{
  home.packages = with pkgs; [
    steam-with-pkgs
    gamescope
    mangohud
    protontricks
    protonup-qt
  ];
}
