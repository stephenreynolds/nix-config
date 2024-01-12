# TODO: add option to make zathura default document viewer
{ config, lib, ... }:

let
  inherit (lib) types mkOption mkEnableOption mkIf;
  cfg = config.my.apps.zathura;
in
{
  options.my.apps.zathura = {
    enable = mkEnableOption "Whether to install the Zathura document viewer";
    options = mkOption {
      type = types.attrs;
      default = {
        selection-clipboard = "clipboard";
        font = "${config.my.desktop.fonts.profiles.regular.family} 12";
        recolor = true;
        guioptions = "none";
      };
      description = "Options to pass to Zathura";
    };
  };

  config = mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      options = cfg.options;
    };
  };
}
