# TODO: add option to make zathura default document viewer
{ config, lib, ... }:
with lib;
let cfg = config.modules.apps.zathura;
in {
  options.modules.apps.zathura = {
    enable = mkEnableOption "Whether to install the Zathura document viewer";
    options = mkOption {
      type = types.attrs;
      default = {
        selection-clipboard = "clipboard";
        font = "${config.modules.desktop.fonts.profiles.regular.family} 12";
        recolor = true;
        guioptions = "none";
      };
      description = "Options to pass to Zathura";
    };
  };

  config = mkIf cfg.enable {
    hm.programs.zathura = {
      enable = true;
      options = cfg.options;
    };
  };
}
