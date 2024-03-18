{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.apps.wezterm;
in {
  options.modules.apps.wezterm = {
    enable = mkEnableOption "Whether to intall Wezterm";
    default = mkEnableOption ''
      Whether to make Wezterm the default terminal emulator
    '';
  };

  config = mkIf cfg.enable {
    hm.home = mkIf cfg.default {
      packages = [
        (pkgs.writeShellScriptBin "xterm" ''
          ${config.hm.programs.wezterm.package}/bin/wezterm "$@"
        '')
      ];
      sessionVariables = { TERMINAL = "wezterm -1"; };
    };

    hm.programs.wezterm = {
      enable = true;
      enableBashIntegration = config.hm.programs.bash.enable;
      enableZshIntegration = config.hm.programs.zsh.enable;
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

        config.window_background_opacity = 0.85

        config.cursor_blink_ease_in = "Constant"
        config.cursor_blink_ease_out = "Constant"

        config.default_cursor_style = "BlinkingBar"

        config.hide_tab_bar_if_only_one_tab = true

        local padding = 10
        config.window_padding = {
          left = padding,
          right = padding,
          top = 0,
          bottom = 0,
        }

        config.scrollback_lines = 10000

        config.check_for_updates = false

        return config
      '';
    };
  };
}
