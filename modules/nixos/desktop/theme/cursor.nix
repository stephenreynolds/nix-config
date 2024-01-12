{ lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.my.desktop.theme.cursor = {
    enable = mkEnableOption "Whether to enable a system-wide cursor theme";
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
}
