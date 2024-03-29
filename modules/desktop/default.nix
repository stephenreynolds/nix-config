{ config, lib, pkgs, ... }:

let cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = lib.mkEnableOption "Enable a desktop environment";
    cursor = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable a cursor theme";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.bibata-cursors;
        description = "The cursor theme to use";
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "Bibata-Modern-Classic";
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
      security.polkit.enable = true;

      modules.desktop.hyprland.enable = lib.mkDefault true;
      modules.desktop.displayManager.regreet.enable = lib.mkDefault true;
    }

    (lib.mkIf cfg.cursor.enable {
      hm.home.pointerCursor = {
        package = cfg.cursor.package;
        name = cfg.cursor.name;
        size = cfg.cursor.size;
        gtk.enable = true;
        x11.enable = true;
      };
    })
  ]);
}
