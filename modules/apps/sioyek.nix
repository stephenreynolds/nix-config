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
        "ui_font" = "${config.modules.desktop.fonts.profiles.regular.family}";
        "font_size" = "12";
        "default_dark_mode" = lib.optionalString config.modules.desktop.theme.gtk.dark "1";
        "super_fast_search" = "1";
        "startup_commands" = "toggle_statusbar";
      };
      bindings = {
        "next_page" = "<C-d>";
        "previous_page" = "<C-u>";
      };
    };

    hm.xdg.mimeApps.defaultApplications = {
      "application/pdf" = "sioyek.desktop";
    };
  };
}

