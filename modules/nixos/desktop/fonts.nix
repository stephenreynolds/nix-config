# Source: https://github.com/Misterio77/nix-config/blob/main/modules/home-manager/fonts.nix
{ config, lib, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkMerge types;

  cfg = config.my.desktop.fonts;

  mkFontOption = kind: {
    family = mkOption {
      type = types.str;
      default = null;
      description = "Family name for ${kind} font profile";
      example = "Fira Code";
    };
    package = mkOption {
      type = types.package;
      default = null;
      description = "Package for ${kind} font profile";
      example = "pkgs.fira-code";
    };
  };
in
{
  options.my.desktop.fonts = {
    profiles = {
      enable = mkEnableOption "Whether to enable font profiles";
      monospace = mkFontOption "monospace";
      regular = mkFontOption "regular";
    };
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra font packages to install";
    };
    subpixelOrder = mkOption {
      type = types.enum [ "rgb" "bgr" "vrgb" "vbgf" "none" ];
      default = "rgb";
      description = ''
        Subpixel order. See fonts.fontconfig.subpixel.rgba
      '';
    };
  };

  config = mkMerge [
    {
      fonts.enableDefaultPackages = true;

      fonts.fontconfig.subpixel.rgba = cfg.subpixelOrder;
    }

    (mkIf cfg.profiles.enable {
      environment.systemPackages = [
        cfg.profiles.monospace.package
        cfg.profiles.regular.package
      ];

      fonts.fontconfig.defaultFonts = {
        monospace = [ cfg.profiles.monospace.family ];
        serif = [ cfg.profiles.regular.family ];
      };
    })
  ];
}
