{ pkgs, config, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or  [ ]) ++ [ "-Dexperimental=true" ];
    });
    systemd.enable = true;
    settings = {
      secondary = {
        mode = "dock";
        layer = "top";
        height = 32;
        width = 100;
        margin = "6";
        position = "bottom";
        modulesacenter = (lib.optionals config.wayland.windowManager.hyprland.enable [
          "wlr/workspaces"
        ]);
        "wlr/workspaces" = {
          on-click = "activate";
        };
      }
    };
    style = {

    };
  };
}
