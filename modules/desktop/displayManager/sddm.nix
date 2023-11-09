{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.displayManager.sddm;
in {
  options.modules.desktop.displayManager.sddm = {
    enable = mkEnableOption "Whether to enable SDDM";
    theme = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable a custom SDDM theme";
      };
      name = mkOption {
        type = types.str;
        default = "chili";
        description = "The name of the theme to use";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.sddm-chili-theme;
        description = "The name of the package to install";
      };
    };
    cursor = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable a custom cursor theme";
      };
      name = mkOption {
        type = types.str;
        default = "macOS-BigSur-White";
        description = "The name of the cursor theme to use";
      };
      size = mkOption {
        type = types.int;
        default = 24;
        description = "The size of the cursor";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.apple-cursor;
        description = "The name of the package to install";
      };
    };
    autoNumlock = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable numlock on boot";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.xserver.enable = true;
      services.xserver.displayManager.sddm.enable = true;
    }

    (mkIf cfg.theme.enable {
      services.xserver.displayManager.sddm.theme = cfg.theme.name;
      environment.systemPackages = [ cfg.theme.package ];
    })

    (mkIf cfg.cursor.enable {
      services.xserver.displayManager.sddm.settings = {
        Theme = {
          CursorTheme = cfg.cursor.name;
          CursorSize = cfg.cursor.size;
        };
      };
      environment.systemPackages = [ cfg.cursor.package ];
    })

    (mkIf cfg.autoNumlock {
      services.xserver.displayManager.sddm.autoNumlock = true;
    })
  ]);
}
