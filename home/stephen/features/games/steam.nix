{ pkgs, ... }:
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
in
{
  home.packages = with pkgs; [
    steam-with-pkgs
    gamescope
    mangohud
    protontricks
    protonup-qt
  ];

  home.persistence = {
    "/persist/home/stephen" = {
      allowOther = true;
      directories = [
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
        "./local/share/applications"
      ];
    };
  };
}
