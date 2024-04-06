{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.hyprland;

  gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
  xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
  defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

  fileBrowser = defaultApp "inode/directory";
in
lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.extraConfig = ''
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
    bind = , P, exec, ${gtk-launch} pavucontrol.desktop
    bind = , P, submap, reset
    bind = , S, exec, ${gtk-launch} steam.desktop
    bind = , S, submap, reset
    bind = , Escape, submap, reset
    submap = reset
  '';
}
