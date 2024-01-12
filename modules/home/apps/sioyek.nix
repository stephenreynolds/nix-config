{ config, lib, ... }:

let
  inherit (lib) foldl foldl' imap0 genList optionalString pipe stringToCharacters length mkEnableOption mkIf;
  inherit (builtins) substring;

  cfg = config.my.apps.sioyek;

  colorscheme = config.my.desktop.theme.colorscheme;

  pow = base: exp: foldl' (a: x: x * a) 1 (genList (_: base) exp);

  hexToDec = v:
    let
      hexToFloat = {
        "0" = 0.0;
        "1" = 1.0;
        "2" = 2.0;
        "3" = 3.0;
        "4" = 4.0;
        "5" = 5.0;
        "6" = 6.0;
        "7" = 7.0;
        "8" = 8.0;
        "9" = 9.0;
        "a" = 10.0;
        "b" = 11.0;
        "c" = 12.0;
        "d" = 13.0;
        "e" = 14.0;
        "f" = 15.0;
      };
      chars = stringToCharacters v;
      charsLen = length chars;
    in
    foldl
      (a: v: a + v)
      0
      (imap0
        (k: v: hexToFloat."${v}" * (pow 16 (charsLen - k - 1)))
        chars);

  hexToRgb = hex: {
    r = hexToDec (substring 0 2 hex) / 255;
    g = hexToDec (substring 2 2 hex) / 255;
    b = hexToDec (substring 4 2 hex) / 255;
  };

  rgbToStr = rgb:
    "${toString rgb.r} ${toString rgb.g} ${toString rgb.b}";
in
{
  options.my.apps.sioyek = {
    enable = mkEnableOption "Whether to install the Sioyek document viewer";
  };

  config = mkIf cfg.enable {
    programs.sioyek = {
      enable = true;
      config = {
        "ui_font" = "${config.my.desktop.fonts.profiles.regular.family}";
        "font_size" = "12";
        "default_dark_mode" = optionalString config.my.desktop.theme.gtk.dark "1";
        "super_fast_search" = "1";
        "startup_commands" = "toggle_custom_color;toggle_statusbar";
        "custom_background_color" = pipe colorscheme.colors.base00 [ hexToRgb rgbToStr ];
        "custom_text_color" = pipe colorscheme.colors.base05 [ hexToRgb rgbToStr ];
      };
      bindings = {
        "next_page" = "<space>";
        "previous_page" = "<S-<space>>";
        "screen_down" = "<C-d>";
        "screen_up" = "<C-u>";
      };
    };

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "sioyek.desktop";
    };
  };
}
