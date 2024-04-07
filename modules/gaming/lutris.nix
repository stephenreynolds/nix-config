{ config, lib, pkgs, ... }:

let cfg = config.modules.gaming.lutris;
in {
  options.modules.gaming.lutris = {
    enable = lib.mkEnableOption {
      type = lib.types.bool;
      default = config.modules.gaming.enable;
      description = "Whether to install Lutris";
    };
  };

  config = lib.mkIf cfg.enable {
    hm.home.packages = [
      (pkgs.lutris.override {
        extraPkgs = p: with p; [
          wineWowPackages.stable
          wineWowPackages.waylandFull
          pixman
          libjpeg
          gnome.zenity
        ];
      })
    ];

    modules.system.persist.state.home.directories = [
      ".config/lutris"
      ".local/share/lutris"
    ];
  };
}
