# Source: https://github.com/Misterio77/nix-config/blob/main/modules/home-manager/fonts.nix
{ lib, config, ... }:
with lib;
let
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
  cfg = config.modules.desktop.fonts;
in {
  options.modules.desktop.fonts = {
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
  };

  config = mkMerge [
    (mkIf cfg.profiles.enable {
      hm.fonts.fontconfig.enable = true;
      hm.home.packages =
        [ cfg.profiles.monospace.package cfg.profiles.regular.package ];
    })

    { hm.home.packages = cfg.extraPackages; }
  ];
}
