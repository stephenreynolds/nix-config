# Source: https://github.com/Misterio77/nix-config/blob/main/modules/home-manager/fonts.nix
{ lib, config, ... }:

let
  mkFontOption = kind: {
    family = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Family name for ${kind} font profile";
      example = "Fira Code";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = null;
      description = "Package for ${kind} font profile";
      example = "pkgs.fira-code";
    };
  };
  cfg = config.modules.desktop.fonts;
in
{
  options.modules.desktop.fonts = {
    profiles = {
      enable = lib.mkEnableOption "Whether to enable font profiles";
      monospace = mkFontOption "monospace";
      regular = mkFontOption "regular";
    };
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra font packages to install";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.profiles.enable {
      hm.fonts.fontconfig.enable = true;
      hm.home.packages = [
        cfg.profiles.monospace.package
        cfg.profiles.regular.package
      ];
    })

    {
      hm.home.packages = cfg.extraPackages;

      fonts.enableDefaultPackages = true;
      fonts.fontconfig.subpixel.rgba = "rgb";
      fonts.fontconfig.hinting.style = "full";
    }
  ];
}
