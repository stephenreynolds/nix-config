{ config, lib, pkgs, ... }:

let
  cfg = config.my.desktop;
  inherit (lib) mkOption mkIf types;
in
{
  options.my.desktop.cursor = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "whether to enable a cursor theme";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.apple-cursor;
      description = "the cursor theme to use";
    };
    name = mkOption {
      type = types.str;
      default = "macos-bigsur-white";
      description = "the name of the cursor theme";
    };
    size = mkOption {
      type = types.int;
      default = 24;
      description = "the size of the cursor";
    };
  };

  config = mkIf cfg.cursor.enable {
    home.pointerCursor = {
      package = cfg.cursor.package;
      name = cfg.cursor.name;
      size = cfg.cursor.size;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
