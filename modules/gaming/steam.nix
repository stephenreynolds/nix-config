{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkIf mkForce optionalString types;
  cfg = config.modules.gaming.steam;
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
    extraProfile = optionalString config.modules.gaming.proton.proton-ge.enable
      "export STEAM_EXTRA_COMPAT_TOOLS_PATHS='${pkgs.proton-ge-bin.steamcompattool}'";
  };
in
{
  options.modules.gaming.steam = {
    enable = mkOption {
      type = types.bool;
      default = config.modules.gaming.enable;
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
    fixDownloadSpeed = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to fix slow Steam download speeds";
    };
  };

  config = mkIf cfg.enable {
    hm.home.packages = [ steam-with-pkgs ];

    modules.system.pipewire.support32Bit = mkForce true;
    modules.system.nvidia.support32Bit = mkForce true;

    modules.system.persist.state.home.directories = [
      ".local/share/Steam"
      ".local/share/applications"
      ".local/share/icons/hicolor"
      ".config/unity3d" # Rimworld
      ".config/StardewValley" # Stardew Valley
    ];

    # Fix download speeds
    hm.home.file.".local/share/Steam/steam_dev.cfg" = {
      enable = cfg.fixDownloadSpeed;
      text = ''
        @nClientDownloadEnableHTTP2PlatformLinux 0
        @fDownloadRateImprovementToAddAnotherConnection 1.0
      '';
    };

    hm.xdg.configFile."autostart/steam.desktop" = {
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
