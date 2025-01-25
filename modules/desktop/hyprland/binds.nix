{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.hyprland;

  gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
  xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
  defaultApp = type: "uwsm app -- ${gtk-launch} $(${xdg-mime} query default ${type})";

  fileBrowser = defaultApp "inode/directory";

  hyprctl = "${config.hm.wayland.windowManager.hyprland.package}/bin/hyprctl";
  jaq = "${pkgs.jaq}/bin/jaq";
in
lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.extraConfig = ''
    $getActiveWorkspaceId = $(${hyprctl} activeworkspace -j | ${jaq} -r '.id')
    bind = $mod ALT, 1, execr, ${hyprctl} keyword bind $mod,1, workspace, $getActiveWorkspaceId
    bind = $mod ALT, 2, execr, ${hyprctl} keyword bind $mod,2, workspace, $getActiveWorkspaceId
    bind = $mod ALT, 3, execr, ${hyprctl} keyword bind $mod,3, workspace, $getActiveWorkspaceId
    bind = $mod ALT, 4, execr, ${hyprctl} keyword bind $mod,4, workspace, $getActiveWorkspaceId
    bind = $mod ALT, 5, execr, ${hyprctl} keyword bind $mod,5, workspace, $getActiveWorkspaceId
    bind = $mod ALT, 6, execr, ${hyprctl} keyword bind $mod,6, workspace, $getActiveWorkspaceId
    bind = $mod ALT, 7, execr, ${hyprctl} keyword bind $mod,7, workspace, $getActiveWorkspaceId
    bind = $mod ALT, 8, execr, ${hyprctl} keyword bind $mod,8, workspace, $getActiveWorkspaceId
    bind = $mod ALT, 9, execr, ${hyprctl} keyword bind $mod,9, workspace, $getActiveWorkspaceId
    bind = $mod ALT, 0, execr, ${hyprctl} keyword bind $mod,0, workspace, $getActiveWorkspaceId

    $getActiveWindowAddress = $(${hyprctl} activewindow -j | ${jaq} -r '.address')
    bind = $mod CTRL, 1, execr, ${hyprctl} keyword bind $mod,1, focuswindow, address:$getActiveWindowAddress
    bind = $mod CTRL, 2, execr, ${hyprctl} keyword bind $mod,2, focuswindow, address:$getActiveWindowAddress
    bind = $mod CTRL, 3, execr, ${hyprctl} keyword bind $mod,3, focuswindow, address:$getActiveWindowAddress
    bind = $mod CTRL, 4, execr, ${hyprctl} keyword bind $mod,4, focuswindow, address:$getActiveWindowAddress
    bind = $mod CTRL, 5, execr, ${hyprctl} keyword bind $mod,5, focuswindow, address:$getActiveWindowAddress
    bind = $mod CTRL, 6, execr, ${hyprctl} keyword bind $mod,6, focuswindow, address:$getActiveWindowAddress
    bind = $mod CTRL, 7, execr, ${hyprctl} keyword bind $mod,7, focuswindow, address:$getActiveWindowAddress
    bind = $mod CTRL, 8, execr, ${hyprctl} keyword bind $mod,8, focuswindow, address:$getActiveWindowAddress
    bind = $mod CTRL, 9, execr, ${hyprctl} keyword bind $mod,9, focuswindow, address:$getActiveWindowAddress
    bind = $mod CTRL, 0, execr, ${hyprctl} keyword bind $mod,0, focuswindow, address:$getActiveWindowAddress

    # Run submap
    bind = $mod, R, submap, run_submap
    submap = run_submap
    bind = , D, exec, ${gtk-launch} vesktop.desktop
    bind = , D, submap, reset
    bind = , F, exec, ${fileBrowser}
    bind = , F, submap, reset
    bind = , M, exec, ${gtk-launch} electron-mail.desktop
    bind = , M, submap, reset
    bind = , O, exec, ${gtk-launch} obsidian.desktop
    bind = , O, submap, reset
    bind = , P, exec, uwsm app -- pavucontrol
    bind = , P, submap, reset
    bind = , S, exec, ${gtk-launch} steam.desktop
    bind = , S, submap, reset
    bind = , Escape, submap, reset
    submap = reset
  '';
}
