{ config, lib, ... }:

let cfg = config.modules.apps.sioyek;
in {
  options.modules.apps.sioyek = {
    enable = lib.mkEnableOption "Whether to install the Sioyek document viewer";
  };

  config = lib.mkIf cfg.enable {
    hm.programs.sioyek = {
      enable = true;
      config = {
        ui_font = "${config.modules.desktop.fonts.profiles.regular.family}";
        font_size = 12;
      };
    };

    hm.xdg.mimeApps.defaultApplications = {
      "application/pdf" = "sioyek.desktop";
    };
  };
}

