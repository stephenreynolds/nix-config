{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.my.desktop.theme.gtk;

  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
  colorscheme = config.my.desktop.theme.colorscheme;

  themeType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "The gtk theme to use";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        description = "The package for the gtk theme to use";
      };
    };
  };
  iconThemeType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "The icon theme to use for gtk applications";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        description =
          "The package for the icon theme to use for gtk applications";
      };
    };
  };
in
{
  options.my.desktop.theme.gtk = {
    enable = lib.mkEnableOption "Whether to use a custom gtk theme";
    dark = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use a dark gtk theme";
    };
    font = {
      name = lib.mkOption {
        type = lib.types.str;
        default = config.my.desktop.fonts.profiles.regular.family;
        description = "The font family to use for gtk applications";
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 11;
        description = "The font size to use for gtk applications";
      };
    };
    theme = lib.mkOption {
      type = lib.types.nullOr themeType;
      default = {
        name = "${colorscheme.slug}";
        package = gtkThemeFromScheme { scheme = colorscheme; };
      };
      description = "The gtk theme to use for gtk applications";
    };
    iconTheme = lib.mkOption {
      type = lib.types.nullOr iconThemeType;
      default = null;
      description = "The icon theme to use for gtk applications";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      gtk = {
        enable = true;
        font = {
          name = cfg.font.name;
          size = cfg.font.size;
        };
        theme = cfg.theme;
        iconTheme = cfg.iconTheme;
        gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      };

      services.xsettingsd = {
        enable = true;
        settings = {
          "Net/ThemeName" = lib.mkIf (cfg.theme != null) "${cfg.theme.name}";
          "Net/IconThemeName" =
            lib.mkIf (cfg.iconTheme != null) "${cfg.iconTheme.name}";
        };
      };
    }

    (lib.mkIf cfg.dark {
      gtk = {
        gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
        gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
      };

      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
        };
      };
    })
  ]);
}
