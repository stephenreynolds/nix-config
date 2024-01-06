{ config, lib, pkgs, ... }:

let cfg = config.my.desktop;
in {
  options.my.desktop = {
    enable = lib.mkEnableOption "Enable a desktop environment";
    cursor = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable a cursor theme";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.apple-cursor;
        description = "The cursor theme to use";
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "macOS-BigSur-White";
        description = "The name of the cursor theme";
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 24;
        description = "The size of the cursor";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      my.desktop.hyprland.enable = lib.mkDefault true;
    }

    (lib.mkIf cfg.cursor.enable {
      home.pointerCursor = {
        package = cfg.cursor.package;
        name = cfg.cursor.name;
        size = cfg.cursor.size;
        gtk.enable = true;
        x11.enable = true;
      };
    })
  ]);
}
