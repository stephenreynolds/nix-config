{ config, pkgs, ... }:
let
  kitty-xterm = pkgs.writeShellScriptBin "xterm" ''
    ${config.programs.kitty.package}/bin/kitty -1 "$@"
  '';
in
{
  home = {
    packages = [ kitty-xterm ];
    sessionVariables = {
      TERMINAL = "kitty -1";
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = config.fontProfiles.monospace.family;
      size = 10;
    };
    settings = {
      shell_integration = "no-rc";
      scrollback_lines = 4000;
      scrollback_pager_history_size = 2048;
      window_padding_width = 10;
      background_opacity = "0.8";
      confirm_os_window_close = 0;
      allow_cloning = "yes";
    };
  };
}
