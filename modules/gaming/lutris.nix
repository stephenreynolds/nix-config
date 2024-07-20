{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf optional types;
  cfg = config.modules.gaming.lutris;
in
{
  options.modules.gaming.lutris = {
    enable = mkEnableOption {
      type = types.bool;
      default = config.modules.gaming.enable;
      description = "Whether to install Lutris";
    };
  };

  config = mkIf cfg.enable {
    hm.home.packages = [
      (pkgs.lutris.override {
        extraPkgs = p: with p; [
          wineWowPackages.stable
          wineWowPackages.waylandFull
          pixman
          libjpeg
          zenity
        ] ++ (optional config.modules.gaming.proton.proton-ge.enable [
          p.proton-ge-bin
        ]);
      })
    ];

    modules.system.persist.state.home.directories = [
      ".config/lutris"
      ".local/share/lutris"
    ];
  };
}
