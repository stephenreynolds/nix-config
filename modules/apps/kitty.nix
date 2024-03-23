{ config, lib, pkgs, ... }:

let
  cfg = config.modules.apps.kitty;
  kitty-xterm = pkgs.writeShellScriptBin "xterm" ''
    ${config.hm.programs.kitty.package}/bin/kitty -1 "$@"
  '';
in
{
  options.modules.apps.kitty = {
    enable = lib.mkEnableOption "Whether to enable Kitty";
    default = lib.mkEnableOption ''
      Whether to make Kitty the default terminal emulator
    '';
  };

  config = lib.mkIf cfg.enable {
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
        scrollback_lines = 10000;
        scrollback_pager_history_size = 2048;
        window_padding_width = 5;
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

      extraConfig = ''
        globinclude generated*.conf
      '';
    };
  };
}
