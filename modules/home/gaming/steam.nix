{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkOption mkIf types optionalString;

  cfg = config.my.gaming.steam;

  steam-with-pkgs = pkgs.steam.override {
    extraPkgs = pkgs:
      with pkgs; [
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
    extraProfile = optionalString config.my.gaming.proton.proton-ge.enable
      "export STEAM_EXTRA_COMPAT_TOOLS_PATHS='${
        inputs.nix-gaming.packages.${pkgs.system}.proton-ge
      }'";
  };
in
{
  options.my.gaming.steam = {
    enable = mkOption {
      type = types.bool;
      default = config.my.gaming.enable;
      description = "Whether to install Steam";
    };
    package = mkOption {
      type = types.package;
      default = steam-with-pkgs;
      description = "Steam package to use";
    };
    autostart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start Steam on login";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ steam-with-pkgs ];

    my.impermanence.persist.directories = [
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];

    xdg.configFile."autostart/steam.desktop" = {
      enable = cfg.autostart;
      text = ''
        [Desktop Entry]
        Name=Steam
        Comment=Application for managing and playing games on Steam
        Exec=steam -silent %U
        Icon=steam
        Terminal=false
        Type=Application
        Categories=Network;FileTransfer;Game;
        MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
        Actions=Store;Community;Library;Servers;Screenshots;News;Settings;BigPicture;Friends;
        PrefersNonDefaultGPU=true
        X-KDE-RunOnDiscreteGpu=true

        [Desktop Action Store]
        Name=Store
        Exec=steam steam://store

        [Desktop Action Community]
        Name=Community
        Exec=steam steam://url/SteamIDControlPage

        [Desktop Action Library]
        Name=Library
        Exec=steam steam://open/games

        [Desktop Action Servers]
        Name=Servers
        Exec=steam steam://open/servers

        [Desktop Action Screenshots]
        Name=Screenshots
        Exec=steam steam://open/screenshots

        [Desktop Action News]
        Name=News
        Exec=steam steam://open/news

        [Desktop Action Settings]
        Name=Settings
        Exec=steam steam://open/settings

        [Desktop Action BigPicture]
        Name=Big Picture
        Exec=steam steam://open/bigpicture

        [Desktop Action Friends]
        Name=Friends
        Exec=steam steam://open/friends
      '';
    };
  };
}
