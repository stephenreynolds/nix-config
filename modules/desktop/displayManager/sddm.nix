{ config, lib, pkgs, ... }:

let cfg = config.modules.desktop.displayManager.sddm;
in {
  options.modules.desktop.displayManager.sddm = {
    enable = lib.mkEnableOption "Whether to enable SDDM";
    theme = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable a custom SDDM theme";
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "chili";
        description = "The name of the theme to use";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.sddm-chili-theme;
        description = "The name of the package to install";
      };
    };
    cursor = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable a custom cursor theme";
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "macOS-BigSur-White";
        description = "The name of the cursor theme to use";
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 24;
        description = "The size of the cursor";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.apple-cursor;
        description = "The name of the package to install";
      };
    };
    autoNumlock = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable numlock on boot";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      services.xserver.enable = true;
      services.xserver.displayManager.sddm.enable = true;
    }

    (lib.mkIf cfg.theme.enable {
      services.xserver.displayManager.sddm.theme = cfg.theme.name;
      environment.systemPackages = [ cfg.theme.package ];
    })

    (lib.mkIf cfg.cursor.enable {
      services.xserver.displayManager.sddm.settings = {
        Theme = {
          CursorTheme = cfg.cursor.name;
          CursorSize = cfg.cursor.size;
        };
      };
      environment.systemPackages = [ cfg.cursor.package ];
    })

    (lib.mkIf cfg.autoNumlock {
      services.xserver.displayManager.sddm.autoNumlock = true;
    })
  ]);
}
