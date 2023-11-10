{ config, lib, pkgs, inputs, ... }:
let
  modifier = "SUPER";

  grimblast = "${
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    }/bin/grimblast";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  playerctl = "${config.hm.services.playerctld.package}/bin/playerctl";
  swappy = lib.getExe pkgs.swappy;
  ags = "${inputs.ags.packages.${pkgs.system}.default}/bin/ags";

  gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
  xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
  defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

  terminal = config.hm.home.sessionVariables.TERMINAL;
  browser = defaultApp "x-scheme-handler/https";
  fileBrowser = defaultApp "inode/directory";

  jq = lib.getExe pkgs.jq;

  killandswitch = pkgs.writeShellScript "killandswitch" ''
    killactive() {
      case $(hyprctl activewindow -j | ${jq} -r ".class") in
        "discord")
          ${pkgs.xdotool}/bin/xdotool getactivewindow windowunmap
          hyprctl dispatch killactive ""
          ;;
        *)
          hyprctl dispatch killactive
      esac
    }

    workspace=$(hyprctl activewindow -j | ${jq} -r ".workspace.id")
    if [[ $workspace == "-99" ]]; then
      killactive
    else
      active=$(hyprctl activeworkspace -j)
      lastwindow=$(echo "$active" | ${jq} -r ".windows == 1")
      killactive
      if [[ $lastwindow == "true" ]]; then
        monitor=$(echo "$active" | ${jq} -r ".monitor")
        lastworkspace=$(hyprctl workspaces -j | ${jq} -r --arg m "$monitor" '[.[] | select(.monitor == $m and .id != -99)] | length == 1')
        if [[ $lastworkspace == "false" ]]; then
          hyprctl dispatch workspace r-1
        fi
      fi
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

  focusempty = pkgs.writeShellScript "focusempty" ''
    active=$(hyprctl activeworkspace -j)
    workspaces=$(hyprctl workspaces -j)
    empty=$(echo "$active" | ${jq} -r ".windows == 0")
    if [[ $empty == "true" ]]; then
      monitor=$(echo "$active" | ${jq} -r ".monitor")
      single=$(echo "$workspaces" | ${jq} -r --arg m "$monitor" '[.[] | select(.monitor == $m and .id != -99)] | length == 1')
      if [[ $single == "false" ]]; then
        hyprctl dispatch workspace previous
      fi
    else
      id=$(echo "$workspaces" | ${jq} -r "max_by(.id).id + 1")
      hyprctl dispatch workspace $id
    fi
  '';

  movetoempty = pkgs.writeShellScript "movetoempty" ''
    multiple=$(hyprctl activeworkspace -j | jq -r ".windows > 1")
    if [[ $multiple == "true" ]]; then
      id=$(hyprctl workspaces -j | ${jq} -r "max_by(.id).id + 1")
      hyprctl dispatch movetoworkspace $id
    fi
  '';
in lib.mkIf config.modules.desktop.hyprland.enable {
  hm.wayland.windowManager.hyprland.extraConfig = ''
    # Launch applications
    bind = ${modifier}, T, exec, ${terminal}
    bind = ${modifier}, W, exec, ${browser}
    bind = ${modifier}, C, exec, ${killandswitch}
    bind = ${modifier}, Space, exec, ${ags} -t overview

    # Cycle through windows
    bind = ${modifier}, Tab, cyclenext

    # Window mode
    bind = ${modifier}, V, fullscreen, 1
    bind = ${modifier} SHIFT, V, fullscreen, 0
    bind = ${modifier}, F, togglefloating
    bind = ${modifier} SHIFT, F, pin
    bind = ${modifier} ALT, F, workspaceopt, allfloat

    # Layout
    bind = ${modifier} SHIFT, L, exec, ${togglelayout}

    ## Dwindle layout
    bind = ${modifier}, U, pseudo
    bind = ${modifier}, J, togglesplit

    ## Master layout
    bind = ${modifier}, S, cyclenext
    bind = ${modifier}, S, layoutmsg, swapwithmaster
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
    bind = ${modifier} CTRL, G, moveoutofgroup
    bind = ${modifier} ALT, G, lockactivegroup, toggle
    bind = ${modifier} ALT, left, moveintogroup, l
    bind = ${modifier} ALT, right, moveintogroup, r
    bind = ${modifier} ALT, up, moveintogroup, u
    bind = ${modifier} ALT, down, moveintogroup, d

    # Switch to next window in group
    bind = ${modifier}, 8, changegroupactive
    bind = ${modifier}, 7, movegroupwindow, b
    bind = ${modifier}, 9, movegroupwindow, f

    # Next/previous workspace on monitor
    bind = ${modifier}, 5, workspace, m-1
    bind = ${modifier}, 6, workspace, m+1
    bind = ${modifier} SHIFT, 5, movetoworkspace, m-1
    bind = ${modifier} SHIFT, 6, movetoworkspace, m+1

    # Next empty workspace on monitor
    bind = ${modifier}, 4, exec, ${focusempty}
    bind = ${modifier} SHIFT, 4, exec, ${movetoempty}

    # Previous workspace
    bind = ${modifier}, 3, workspace, previous
    bind = ${modifier} SHIFT, 3, movetoworkspace, previous

    # Special workspaces
    bind = ${modifier} SHIFT, 0, movetoworkspace, special
    bind = ${modifier}, 0, togglespecialworkspace

    # Move to monitor
    bind = ${modifier}, 1, focusmonitor, l
    bind = ${modifier}, 2, focusmonitor, r
    bind = ${modifier} SHIFT, 1, movewindow, mon:l
    bind = ${modifier} SHIFT, 2, movewindow, mon:r
    bind = ${modifier} CTRL, 1, movecurrentworkspacetomonitor, l
    bind = ${modifier} CTRL, 2, movecurrentworkspacetomonitor, r

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
    bind = , M, exec, ${pkgs.thunderbird}
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