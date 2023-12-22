{ config, lib, pkgs, ... }:

let
  cfg = config.modules.apps.kitty;
  kitty-xterm = pkgs.writeShellScriptBin "xterm" ''
    ${config.hm.programs.kitty.package}/bin/kitty -1 "$@"
  '';

  colorscheme = config.modules.desktop.theme.colorscheme;
in
{
  options.modules.apps.kitty = {
    enable = lib.mkEnableOption "Whether to enable Kitty";
    default = lib.mkEnableOption ''
      Whether to make Kitty the default terminal emulator
    '';
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hm.home = lib.mkIf cfg.default {
        packages = [ kitty-xterm ];
        sessionVariables = { TERMINAL = "kitty -1"; };
      };

      hm.programs.kitty = {
        enable = true;
        font = {
          name = config.modules.desktop.fonts.profiles.monospace.family;
          size = 10;
        };
        settings = {
          shell_integration = "no-rc";
          scrollback_lines = 4000;
          scrollback_pager_history_size = 2048;
          window_padding_width = 10;
          confirm_os_window_close = 0;
          allow_cloning = "yes";
          disable_ligatures = "cursor";
          copy_on_select = "yes";
          strip_trailing_spaces = "smart";
          show_hyperlink_targets = "yes";

          enabled_layouts = "tall,grid";

          background_opacity = "1";
          dynamic_background_opacity = "yes";
        };
        keybindings = {
          "alt+left" = "neighboring_window left";
          "alt+right" = "neighboring_window right";
          "alt+up" = "neighboring_window up";
          "alt+down" = "neighboring_window down";

          "shift+left" = "move_window left";
          "shift+right" = "move_window right";
          "shift+up" = "move_window up";
          "shift+down" = "move_window down";

          "ctrl+f2" = "detach_window";
          "ctrl+f3" = "detach_window new-tab";
          "ctrl+f4" = "detach_window tab-prev";
          "ctrl+f5" = "detach_window tab-left";
          "ctrl+f6" = "detach_window tab-right";
          "ctrl+f9" = "close_other_windows_in_tab";

          "ctrl+shift+enter" = "new_window_with_cwd";
          "ctrl+shift+t" = "new_tab_with_cwd";
          "ctrl+shift+n" = "new_os_window_with_cwd";

          "ctrl+c" = "copy_or_interrupt";
        };
      };
    }

    (lib.mkIf (colorscheme != null) {
      hm.programs.kitty.settings =
        let inherit (colorscheme) colors;
        in {
          foreground = "#${colors.base05}";
          background = "#${colors.base00}";
          selection_background = "#${colors.base05}";
          selection_foreground = "#${colors.base00}";
          url_color = "#${colors.base04}";
          cursor = "#${colors.base05}";
          active_border_color = "#${colors.base03}";
          inactive_border_color = "#${colors.base01}";
          active_tab_background = "#${colors.base00}";
          active_tab_foreground = "#${colors.base05}";
          inactive_tab_background = "#${colors.base01}";
          inactive_tab_foreground = "#${colors.base04}";
          tab_bar_background = "#${colors.base01}";
          color0 = "#${colors.base00}";
          color1 = "#${colors.base08}";
          color2 = "#${colors.base0B}";
          color3 = "#${colors.base0A}";
          color4 = "#${colors.base0D}";
          color5 = "#${colors.base0E}";
          color6 = "#${colors.base0C}";
          color7 = "#${colors.base05}";
          color8 = "#${colors.base03}";
          color9 = "#${colors.base08}";
          color10 = "#${colors.base0B}";
          color11 = "#${colors.base0A}";
          color12 = "#${colors.base0D}";
          color13 = "#${colors.base0E}";
          color14 = "#${colors.base0C}";
          color15 = "#${colors.base07}";
          color16 = "#${colors.base09}";
          color17 = "#${colors.base0F}";
          color18 = "#${colors.base01}";
          color19 = "#${colors.base02}";
          color20 = "#${colors.base04}";
          color21 = "#${colors.base06}";
        };
    })
  ]);
}
