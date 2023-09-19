{ lib, config, pkgs, inputs, ... }:
let
  modifier = "SUPER";

  grimblast = "${inputs.hypr-contrib.packages.${pkgs.system}.grimblast}/bin/grimblast";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  playerctl = "${config.services.playerctld.package}/bin/playerctl";
  swappy = lib.getExe pkgs.swappy;
  wofi = "${config.programs.wofi.package}/bin/wofi";

  gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
  xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
  defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

  terminal = config.home.sessionVariables.TERMINAL;
  browser = defaultApp "x-scheme-handler/https";
  fileBrowser = defaultApp "inode/directory";

  jq = lib.getExe pkgs.jq;

  killandswitch = pkgs.writeShellScript "killandswitch" ''
    single=$(hyprctl activeworkspace -j | ${jq} -r ".windows == 1")
    hyprctl dispatch killactive
    if [[ $single == "true" ]]; then
        hyprctl dispatch workspace m-1
    fi
  '';

  togglelayout = pkgs.writeShellScript "togglelayout" ''
    layout=$(hyprctl -j getoption general:layout | ${jq} -r ".str")
    if [[ $layout == "master" ]]; then
      hyprctl keyword general:layout "dwindle"
    else
      hyprctl keyword general:layout "master"
    fi
  '';

  cyclemaster = pkgs.writeShellScript "swapmaster" ''
    hyprctl dispatch cyclenext
    hyprctl dispatch layoutmsg swapwithmaster
  '';
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    # Launch applications
    bind = ${modifier}, T, exec, ${terminal}
    bind = ${modifier}, W, exec, ${browser}
    bind = ${modifier}, C, exec, ${killandswitch}
    bind = ${modifier}, Space, exec, pkill wofi || ${wofi} --show drun --normal-window --allow-images

    # Window mode
    bind = ${modifier}, V, fullscreen, 1
    bind = ${modifier} SHIFT, V, fullscreen, 0
    bind = ${modifier}, F, togglefloating
    bind = ${modifier} SHIFT, F, pin

    # Layout
    bind = ${modifier} SHIFT, L, exec, ${togglelayout}

    ## Dwindle layout
    bind = ${modifier}, U, pseudo
    bind = ${modifier}, J, togglesplit
    bind = ${modifier}, L, submap, preselect_submap
    submap = preselect_submap
    bind = , up, layoutmsg, preselect u
    bind = , up, submap, reset
    bind = , down, layoutmsg, preselect d
    bind = , down, submap, reset
    bind = , left, layoutmsg, preselect l
    bind = , left, submap, reset
    bind = , right, layoutmsg, preselect r
    bind = , right, submap, reset
    bind = , Escape, submap, reset
    submap = reset

    ## Master layout
    bind = ${modifier}, S, exec, ${cyclemaster}
    bind = ${modifier}, L, layoutmsg, orientationcycle center left

    # Focus last window
    bind = ${modifier}, D, focuscurrentorlast

    # Move focus with {modifier} + arrow keys
    bind = ${modifier}, left, movefocus, l
    bind = ${modifier}, right, movefocus, r
    bind = ${modifier}, up, movefocus, u
    bind = ${modifier}, down, movefocus, d

    # Move window with {modifier} + Shift + arrow keys
    bind = ${modifier} SHIFT, left, movewindow, l
    bind = ${modifier} SHIFT, right, movewindow, r
    bind = ${modifier} SHIFT, up, movewindow, u
    bind = ${modifier} SHIFT, down, movewindow, d

    # Resize window with {modifier} + Ctrl + arrow keys
    binde = ${modifier} CTRL, left, resizeactive, -10 0
    binde = ${modifier} CTRL, right, resizeactive, 10 0
    binde = ${modifier} CTRL, up, resizeactive, 0 -10
    binde = ${modifier} CTRL, down,resizeactive, 0 10

    # Group window
    bind = ${modifier}, G, togglegroup
    bind = ${modifier} SHIFT, G, changegroupactive
    bind = ${modifier} CTRL, G, moveoutofgroup
    bind = ${modifier} ALT, G, lockactivegroup, toggle
    bind = ${modifier} ALT, left, moveintogroup, l
    bind = ${modifier} ALT, right, moveintogroup, r
    bind = ${modifier} ALT, up, moveintogroup, u
    bind = ${modifier} ALT, down, moveintogroup, d
    bind = ${modifier} CTRL, 8, movegroupwindow, f

    # Switch to next window in group
    bind = ${modifier} ALT, 7, changegroupactive

    # Focus next/previous workspace on monitor
    bind = ${modifier}, 5, workspace, m-1
    bind = ${modifier}, 6, workspace, m+1

    # Move window to next/previous workspace on monitor
    bind = ${modifier} SHIFT, 5, movetoworkspace, m-1
    bind = ${modifier} SHIFT, 6, movetoworkspace, m+1

    # Focus next/previous workspace on monitor (including empty)
    bind = ${modifier}, 2, workspace, r-1
    bind = ${modifier}, 3, workspace, r+1

    # Move window to next/previous workspace on monitor
    bind = ${modifier} SHIFT, 2, movetoworkspace, r-1
    bind = ${modifier} SHIFT, 3, movetoworkspace, r+1

    # Special workspaces
    bind = ${modifier} SHIFT, 0, movetoworkspace, special
    bind = ${modifier}, 0, togglespecialworkspace

    # Scroll through existing workspaces with {modifier} + scroll
    bind = ${modifier}, mouse_down, workspace, m+1
    bind = ${modifier}, mouse_up, workspace, m-1

    # Move/resize windows with modifier + LMB/RMB and dragging
    bindm = ${modifier}, mouse:272, movewindow
    bindm = ${modifier}, mouse:273, resizewindow

    # Volume keys
    $volume_helper_cmd = ~/.config/hypr/scripts/volume-helper
    bindle = , XF86AudioRaiseVolume, exec, $volume_helper_cmd --limit "$volume_limit" --increase "$volume_step"
    bindle = , XF86AudioLowerVolume, exec, $volume_helper_cmd --limit "$volume_limit" --decrease "$volume_step"
    bindl = , XF86AudioMute, exec, ${pactl} set-sink-mute @DEFAULT_SINK@ toggle && $volume_helper_cmd
    bindl = , XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle

    # Media keys
    bind = , XF86AudioForward, exec, ${playerctl} position +10
    bind = , XF86AudioRewind, exec, ${playerctl} position -10
    bind = , XF86AudioNext, exec, ${playerctl} next
    bind = , XF86AudioPrev, exec, ${playerctl} previous
    bind = , XF86AudioPause, exec, ${playerctl} pause
    bindl = , XF86AudioPlay, exec, ${playerctl} play-pause
    bindl = , XF86AudioStop, exec, ${playerctl} stop

    # Capture the active output
    bind = , Print, exec, ${grimblast} save output - | ${swappy} -f -
    # Capture the active window
    bind = ALT, Print, exec, ${grimblast} save active - | ${swappy} -f -
    # Capture the active window
    bind = CTRL, Print, exec, ${grimblast} save area - | ${swappy} -f -

    # Passthrough submap
    bind = ${modifier}, Pause, submap, passthrough_submap
    submap = passthrough_supmap
    bind = ${modifier}, Pause, submap, reset
    submap = reset

    # Run submap
    bind = ${modifier}, R, submap, run_submap
    submap = run_submap
    bind = , D, exec, ${pkgs.discord}
    bind = , D, submap, reset
    bind = , F, exec, ${fileBrowser}
    bind = , F, submap, reset
    bind = , M, exec, ${pkgs.mailspring}
    bind = , M, submap, reset
    bind = , P, exec, ${pkgs.pavucontrol}
    bind = , P, submap, reset
    bind = , S, exec, ${pkgs.steam}
    bind = , S, submap, reset
    bind = , Escape, submap, reset
    submap = reset

    # Global keybinds
    bind = ${modifier} CTRL, E, pass, ^(ClickUp)$
    bind = ${modifier} CTRL, N, pass, ^(ClickUp)$
  '';
}
