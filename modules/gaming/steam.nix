{ config, lib, pkgs, inputs, ... }:
with lib;
let
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
      "export STEAM_EXTRA_COMPAT_TOOLS_PATHS='${
        inputs.nix-gaming.packages.${pkgs.system}.proton-ge
      }'";
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
  };

  config = mkIf cfg.enable {
    hm.home.packages = [ steam-with-pkgs ];

    modules.system.pipewire.support32Bit = mkForce true;
    modules.system.nvidia.support32Bit = mkForce true;
  };
}
