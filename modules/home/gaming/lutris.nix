{ config, lib, pkgs, ... }:

let
  inherit (lib) types mkEnableOption mkIf;
  cfg = config.my.gaming.lutris;
in
{
  options.my.gaming.lutris = {
    enable = mkEnableOption {
      type = types.bool;
      default = config.my.gaming.enable;
      description = "Whether to install Lutris";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.lutris.override {
        extraPkgs = p: [
          p.wineWowPackages.staging
          p.pixman
          p.libjpeg
          p.gnome.zenity
        ];
      })
    ];

    my.impermanence.persist.directories = [
      ".config/lutris"
      ".local/share/lutris"
    ];
  };
}
