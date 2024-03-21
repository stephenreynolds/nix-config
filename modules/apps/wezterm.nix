{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.apps.wezterm;
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
      packages = [
        (mkIf cfg.default (pkgs.writeShellScriptBin "xterm" ''
          ${config.hm.programs.wezterm.package}/bin/wezterm "$@"
        ''))
      ];
      sessionVariables = { TERMINAL = "wezterm -1"; };
    };

    hm.programs.wezterm = {
      enable = true;
      enableBashIntegration = config.hm.programs.bash.enable;
      enableZshIntegration = config.hm.programs.zsh.enable;
      extraConfig = /* lua */ ''
        local config = {}
        if wezterm.config_builder then
        	config = wezterm.config_builder()
        end

        config.check_for_updates = false

        -- https://github.com/wez/wezterm/issues/5103
        config.enable_wayland = false

        -- Font
        config.font = wezterm.font_with_fallback({
        	{ family = "CaskaydiaCove Nerd Font", weight = "DemiBold" },
        	{ family = "JetBrains Mono", weight = "DemiBold" },
        })
        config.font_size = 10
        config.freetype_load_target = "HorizontalLcd"

        local enable_ligatures = true
        if not enable_ligatures then
        	config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
        end

        -- Tabs
        config.tab_bar_at_bottom = true
        config.use_fancy_tab_bar = false
        config.hide_tab_bar_if_only_one_tab = true

        -- Window
        config.window_padding = {
        	left = 0,
        	right = 0,
        	top = 0,
        	bottom = 0,
        }
        config.window_background_opacity = 0.9
        config.window_close_confirmation = "NeverPrompt"

        -- Cursor
        config.default_cursor_style = "BlinkingBar"
        config.cursor_blink_ease_in = "Constant"
        config.cursor_blink_ease_out = "Constant"

        -- Scroll
        config.scrollback_lines = 10000

        config.use_ime = false

        -- Load pywal theme
        wezterm.on("window-config-reloaded", function()
        	os.execute("wal -Rqnet")
        end)

        return config
      '';
    };
  };
}
