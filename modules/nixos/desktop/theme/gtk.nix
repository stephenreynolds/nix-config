{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkOption types;

  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
  colorscheme = config.my.desktop.theme.colorscheme;

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
in
{
  options.my.desktop.theme.gtk = {
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
}
