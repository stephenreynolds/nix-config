# TODO: add option to make zathura default document viewer
{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.zathura;
in {
  options.modules.apps.zathura = {
    enable = lib.mkEnableOption "Whether to install the Zathura document viewer";
    options = lib.mkOption {
      type = lib.types.attrs;
      default = {
        selection-clipboard = "clipboard";
        font = "${config.modules.desktop.fonts.profiles.regular.family} 12";
        recolor = true;
        guioptions = "none";
      };
      description = "Options to pass to Zathura";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hm.programs.zathura = {
        enable = true;
        options = cfg.options;
      };
    }

    (lib.mkIf config.modules.system.security.firejail.enable {
      programs.firejail.wrappedBinaries.zathura = {
        executable = "${config.hm.programs.zathura.package}/bin/zathura";
        profile = "${pkgs.firejail}/etc/firejail/zathura.profile";
      };
    })
  ]);
}
