{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.modules.apps.kitty;
  kitty-xterm = pkgs.writeShellScriptBin "xterm" ''
    ${config.hm.programs.kitty.package}/bin/kitty -1 "$@"
  '';

  colorscheme = config.modules.desktop.theme.colorscheme;
  text-colors = inputs.nix-colors.colorSchemes.catppuccin-mocha;
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

          background_opacity = "0.9";
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
      hm.programs.kitty.settings = lib.mkMerge [
        (
          let inherit (colorscheme) palette; in {
            background = "#${palette.base00}";
          }
        )

        (
          let inherit (text-colors) palette; in {
            foreground = "#${palette.base05}";
            selection_background = "#${palette.base05}";
            selection_foreground = "#${palette.base00}";
            url_color = "#${palette.base04}";
            cursor = "#${palette.base05}";
            active_border_color = "#${palette.base03}";
            inactive_border_color = "#${palette.base01}";
            active_tab_background = "#${palette.base00}";
            active_tab_foreground = "#${palette.base05}";
            inactive_tab_background = "#${palette.base01}";
            inactive_tab_foreground = "#${palette.base04}";
            tab_bar_background = "#${palette.base01}";
            color0 = "#${palette.base00}";
            color1 = "#${palette.base08}";
            color2 = "#${palette.base0B}";
            color3 = "#${palette.base0A}";
            color4 = "#${palette.base0D}";
            color5 = "#${palette.base0E}";
            color6 = "#${palette.base0C}";
            color7 = "#${palette.base05}";
            color8 = "#${palette.base03}";
            color9 = "#${palette.base08}";
            color10 = "#${palette.base0B}";
            color11 = "#${palette.base0A}";
            color12 = "#${palette.base0D}";
            color13 = "#${palette.base0E}";
            color14 = "#${palette.base0C}";
            color15 = "#${palette.base07}";
            color16 = "#${palette.base09}";
            color17 = "#${palette.base0F}";
            color18 = "#${palette.base01}";
            color19 = "#${palette.base02}";
            color20 = "#${palette.base04}";
            color21 = "#${palette.base06}";
          }
        )
      ];

      hm.programs.kitty.extraConfig = ''
        globinclude generated*.conf
      '';
    })
  ]);
}
