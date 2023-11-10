{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.apps.wezterm;
  wezterm-xterm = pkgs.writeShellScriptBin "xterm" ''
    ${config.hm.programs.wezterm.package}/bin/wezterm -1 "$@"
  '';

  colorscheme = config.modules.desktop.theme.colorscheme;
in
{
  options.modules.apps.wezterm = {
    enable = mkEnableOption "Whether to intall Wezterm";
    default = mkEnableOption ''
      Whether to make Wezterm the default terminal emulator
    '';
  };

  config = mkIf cfg.enable {
    hm.home = mkIf cfg.default {
      packages = [ wezterm-xterm ];
      sessionVariables = { TERMINAL = "wezterm -1"; };
    };

    hm.programs.wezterm = {
      enable = true;
      enableBashIntegration = config.hm.programs.bash.enable;
      enableZshIntegration = config.hm.programs.zsh.enable;
      colorSchemes =
        let inherit (colorscheme) colors;
        in mkIf (colorscheme != null) {
          base16 = {
            ansi = [
              "#${colors.base00}"
              "#${colors.base08}"
              "#${colors.base0B}"
              "#${colors.base0A}"
              "#${colors.base0D}"
              "#${colors.base0E}"
              "#${colors.base0C}"
              "#${colors.base05}"
            ];
            brights = [
              "#${colors.base03}"
              "#${colors.base08}"
              "#${colors.base0B}"
              "#${colors.base0A}"
              "#${colors.base0D}"
              "#${colors.base0E}"
              "#${colors.base0C}"
              "#${colors.base07}"
            ];
            background = "#${colors.base00}";
            foreground = "#${colors.base05}";
            cursor_bg = "#${colors.base05}";
            cursor_fg = "#${colors.base05}";
            cursor_border = "#${colors.base05}";
            selection_bg = "#${colors.base05}";
            selection_fg = "#${colors.base00}";
            tab_bar = {
              background = "#${colors.base01}";
              active_tab = {
                bg_color = "#${colors.base00}";
                fg_color = "#${colors.base05}";
              };
              inactive_tab = {
                bg_color = "#${colors.base01}";
                fg_color = "#${colors.base04}";
              };
            };
          };
        };
      extraConfig = ''
        local config = {}

        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        config.font = wezterm.font({
          family = "${config.modules.desktop.fonts.profiles.monospace.family}"
        })
        config.font_size = 10
        config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

        config.color_scheme = "base16"

        config.window_background_opacity = 0.85

        config.cursor_blink_ease_in = "Constant"
        config.cursor_blink_ease_out = "Constant"

        config.default_cursor_style = "BlinkingBar"

        config.hide_tab_bar_if_only_one_tab = true

        local padding = 10
        config.window_padding = {
          left = padding,
          right = padding,
          top = padding,
          bottom = padding,
        }

        config.scrollback_lines = 4000

        config.check_for_updates = false

        return config
      '';
    };
  };
}
