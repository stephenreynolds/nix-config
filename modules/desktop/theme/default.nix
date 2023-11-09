{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.theme;
in {
  options.modules.desktop.theme = {
    enable = mkEnableOption "Whether to use a custom theme";
    colorscheme = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = "The colorscheme to use";
    };
  };

  config = mkIf cfg.enable (mkMerge [{
    modules.desktop.theme.gtk.enable = true;

    hm.qt = {
      enable = true;
      platformTheme = "gtk";
      style = {
        name = "gtk2";
        package = pkgs.qt6Packages.qt6gtk2;
      };
    };
  }]);
}
