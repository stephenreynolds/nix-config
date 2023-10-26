{ pkgs, ... }:
let
  modifier = "SUPER";
  pypr = "${pkgs.pyprland}/bin/pypr";
in {
  home.packages = [ pkgs.pyprland ];

  xdg.configFile."hypr/pyprland.json".text = ''
    {
      "pyprland": {
        "plugins": ["expose"]
      }
    }
  '';

  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = ${pypr}

    bind = ${modifier} SHIFT, N, exec, ${pypr} toggle_minimized
    bind = ${modifier}, N, togglespecialworkspace, minimized
  '';
}
