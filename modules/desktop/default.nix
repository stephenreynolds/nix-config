{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = mkEnableOption "Enable a desktop environment";
    cursor = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable a cursor theme";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.apple-cursor;
        description = "The cursor theme to use";
      };
      name = mkOption {
        type = types.str;
        default = "macOS-BigSur-White";
        description = "The name of the cursor theme";
      };
      size = mkOption {
        type = types.int;
        default = 24;
        description = "The size of the cursor";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      security.polkit.enable = true;

      modules.desktop.hyprland.enable = mkDefault true;
      modules.desktop.displayManager.sddm.enable = mkDefault true;
    }

    (mkIf cfg.cursor.enable {
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
