{ config, lib, pkgs, ... }:

let cfg = config.modules.desktop.theme;
in {
  options.modules.desktop.theme = {
    enable = lib.mkEnableOption "Whether to use a custom theme";
    colorscheme = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
      description = "The colorscheme to use";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [{
    modules.desktop.theme.gtk.enable = true;

    hm.qt = {
      enable = true;
      platformTheme.name = "gtk";
      style = {
        name = "gtk2";
        package = pkgs.qt6Packages.qt6gtk2;
      };
    };
  }]);
}
