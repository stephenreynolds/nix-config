{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf optionalString;
  cfg = config.modules.apps.sioyek;
in {
  options.modules.apps.sioyek = {
    enable = mkEnableOption "Whether to install the Sioyek document viewer";
  };

  config = mkIf cfg.enable {
    hm.programs.sioyek = {
      enable = true;
      config = {
        "ui_font" = "${config.modules.desktop.fonts.profiles.regular.family}";
        "font_size" = "12";
        "default_dark_mode" =
          optionalString config.modules.desktop.theme.gtk.dark "1";
        "super_fast_search" = "1";
        "startup_commands" = "toggle_custom_color;toggle_statusbar";
      };
      bindings = {
        "next_page" = "<space>";
        "previous_page" = "<S-<space>>";
        "screen_down" = "<C-d>";
        "screen_up" = "<C-u>";
      };
    };

    hm.xdg.mimeApps.defaultApplications = {
      "application/pdf" = "sioyek.desktop";
    };
  };
}

