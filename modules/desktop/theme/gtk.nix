{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.modules.desktop.theme.gtk;

  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
  colorscheme = config.modules.desktop.theme.colorscheme;

  themeType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "The gtk theme to use";
      };
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = "The package for the gtk theme to use";
      };
    };
  };
  iconThemeType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "The icon theme to use for gtk applications";
      };
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        description =
          "The package for the icon theme to use for gtk applications";
      };
    };
  };
in {
  options.modules.desktop.theme.gtk = {
    enable = mkEnableOption "Whether to use a custom gtk theme";
    dark = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use a dark gtk theme";
    };
    font = {
      name = mkOption {
        type = types.str;
        default = config.modules.desktop.fonts.profiles.regular.family;
        description = "The font family to use for gtk applications";
      };
      size = mkOption {
        type = types.int;
        default = 11;
        description = "The font size to use for gtk applications";
      };
    };
    theme = mkOption {
      type = types.nullOr themeType;
      default = {
        name = "${colorscheme.slug}";
        package = gtkThemeFromScheme { scheme = colorscheme; };
      };
      description = "The gtk theme to use for gtk applications";
    };
    iconTheme = mkOption {
      type = types.nullOr iconThemeType;
      default = null;
      description = "The icon theme to use for gtk applications";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.gtk = {
        enable = true;
        font = {
          name = cfg.font.name;
          size = cfg.font.size;
        };
        theme = cfg.theme;
        iconTheme = cfg.iconTheme;
        gtk2.configLocation = "${config.hm.xdg.configHome}/gtk-2.0/gtkrc";
      };

      hm.services.xsettingsd = {
        enable = true;
        settings = {
          "Net/ThemeName" = mkIf (cfg.theme != null) "${cfg.theme.name}";
          "Net/IconThemeName" =
            mkIf (cfg.iconTheme != null) "${cfg.iconTheme.name}";
        };
      };
    }

    (mkIf cfg.dark {
      hm.gtk = {
        gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
        gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
      };

      hm.dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
        };
      };
    })
  ]);
}
