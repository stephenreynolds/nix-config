{ config, ... }:
let
  inherit (config.colorscheme) colors;
in
{
  programs.wezterm = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    colorSchemes = {
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
    extraConfig = /* lua */ ''
        local config = {}

        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        config.font = wezterm.font({
          family = "${config.fontProfiles.monospace.family}"
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
}
