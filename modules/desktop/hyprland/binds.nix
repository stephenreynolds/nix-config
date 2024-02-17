{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.modules.desktop.hyprland;

  modifier = "SUPER";

  grimblast = "${
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    }/bin/grimblast";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  playerctl = "${config.hm.services.playerctld.package}/bin/playerctl";
  swappy = lib.getExe pkgs.swappy;
  ags = "ags -b hyprland";

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
        monitor=$(echo "$active" | ${jq} -r ".monitorID")
        lastworkspace=$(hyprctl workspaces -j | ${jq} -r "map(select(.monitorID == $monitor and .id != -99)) | length == 1")
        if [[ $lastworkspace == "false" ]]; then
          hyprctl dispatch workspace m-1
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
    monitor=$(echo "$active" | ${jq} -r ".monitorID")
    workspaces=$(hyprctl workspaces -j)
    empty=$(echo "$active" | ${jq} -r ".windows == 0")
    if [[ $empty == "true" ]]; then
      workspaces_on_monitor=$(echo "$workspaces" | ${jq} -r "map(select(.monitorID == $monitor and .id != -99))")
      only_workspace=$(echo "$workspaces_on_monitor" | ${jq} -r "length == 1")
      if [[ $only_workspace == "false" ]]; then
        hyprctl dispatch workspace previous
      fi
    else
      id=$(echo "$workspaces" | ${jq} -r "max_by(.id).id + 1")
      hyprctl dispatch workspace $id
    fi
  '';

  movetoempty = pkgs.writeShellScript "movetoempty" ''
    active=$(hyprctl activeworkspace -j) 
    monitor=$(echo "$active" | ${jq} -r ".monitorID")
    workspaces=$(hyprctl workspaces -j)
    workspaces_on_monitor=$(echo "$workspaces" | ${jq} -r "map(select(.monitorID == $monitor and .id != -99))")

    last_id=$(echo "$workspaces_on_monitor" | ${jq} -r "max_by(.id).id")
    should_move=$(echo "$active" | ${jq} -r ".id != $last_id or .windows > 1")
    if [[ $should_move == "true" ]]; then
      hyprctl --batch "dispatch movetoworkspace $last_id ; dispatch movetoworkspace r+1"
    fi
  '';

  volumehelper = pkgs.writeShellScript "volumehelper" ''
    if ! command -v ${pactl} >/dev/null; then
    	exit 0
    fi

    DEFAULT_STEP=5
    LIMIT=''${LIMIT:-100}
    SINK="@DEFAULT_SINK@"

    clamp() {
    	if [ "$1" -lt 0 ]; then
    		echo "0"
    	elif [ "$1" -gt "$LIMIT" ]; then
    		echo "$LIMIT"
    	else
    		echo "$1"
    	fi
    }

    get_sink_volume() {
    	ret=$(${pactl} get-sink-volume "$1")
    	ret=''${ret%%%*}
    	ret=''${ret##* }
    	echo "$ret"
    	unset ret
    }

    CHANGE=0
    VOLUME=-1

    while true; do
    	case $1 in
    	--sink)
    		SINK=''${2:-$SINK}
    		shift
    		;;
    	-l | --limit)
    		LIMIT=$((''${2:-$LIMIT}))
    		shift
    		;;
    	--set-volume)
    		VOLUME=$(($2))
    		shift
    		;;
    	-i | --increase)
    		CHANGE=$((''${2:-$DEFAULT_STEP}))
    		shift
    		;;
    	-d | --decrease)
    		CHANGE=$((-''${2:-$DEFAULT_STEP}))
    		shift
    		;;
    	*)
    		break
    		;;
    	esac
    	shift
    done
  
    GTK_PLAY=${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play
    VOLUME_CHANGE_SOUND=${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga
    if [ "$CHANGE" -ne 0 ]; then
    	VOLUME=$(get_sink_volume "$SINK")
    	VOLUME=$((VOLUME + CHANGE))
    	${pactl} set-sink-volume "$SINK" "$(clamp "$VOLUME")%"
    	$GTK_PLAY -f $VOLUME_CHANGE_SOUND
    elif [ "$VOLUME" -ge 0 ]; then
    	${pactl} set-sink-volume "$SINK" "$(clamp "$VOLUME")%"
    	$GTK_PLAY -f $VOLUME_CHANGE_SOUND
    fi

    # Display desktop notification

    if ! command -v notify-send >/dev/null; then
    	exit 0
    fi

    VOLUME=$(get_sink_volume "$SINK")
    TEXT="Volume: ''${VOLUME}%"
    case $(${pactl} get-sink-mute "$SINK") in
    *yes)
    	TEXT="Volume: muted"
    	VOLUME=0
    	;;
    esac

    ${ags} -r 'indicator.speaker()' 
  '';
in
lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.extraConfig = ''
    # Launch applications
    bind = ${modifier}, T, exec, ${terminal}
    bind = ${modifier}, W, exec, ${browser}
    bind = ${modifier} SHIFT, W, exec, firefox --private-window
    bind = ${modifier}, C, exec, ${killandswitch}

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
    bind = ${modifier}, S, layoutmsg, rollnext
    bind = ${modifier} SHIFT, S, layoutmsg, rollprev
    bind = ${modifier}, L, layoutmsg, orientationcycle right center left

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
    binde = ${modifier} CTRL, down, resizeactive, 0 10

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
    bind = ${modifier}, 5, exec, ags -b hyprland -r 'indicator.workspace()'
    bind = ${modifier}, 6, workspace, m+1
    bind = ${modifier}, 6, exec, ags -b hyprland -r 'indicator.workspace()'
    bind = ${modifier} SHIFT, 5, movetoworkspace, m-1
    bind = ${modifier} SHIFT, 5, exec, ags -b hyprland -r 'indicator.workspace()'
    bind = ${modifier} SHIFT, 6, movetoworkspace, m+1
    bind = ${modifier} SHIFT, 6, exec, ags -b hyprland -r 'indicator.workspace()'
    bind = ${modifier} CTRL, 5, movetoworkspace, r-1
    bind = ${modifier} CTRL, 5, exec, ags -b hyprland -r 'indicator.workspace()'

    # Next empty workspace on monitor
    bind = ${modifier}, 4, exec, ${focusempty}
    bind = ${modifier}, 4, exec, ags -b hyprland -r 'indicator.workspace()'
    bind = ${modifier} SHIFT, 4, exec, ${movetoempty}
    bind = ${modifier} SHIFT, 4, exec, ags -b hyprland -r 'indicator.workspace()'

    # Previous workspace
    bind = ${modifier}, 3, workspace, previous
    bind = ${modifier}, 3, exec, ags -b hyprland -r 'indicator.workspace()'
    bind = ${modifier} SHIFT, 3, movetoworkspace, previous
    bind = ${modifier} SHIFT, 3, exec, ags -b hyprland -r 'indicator.workspace()'

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
    bind = ${modifier}, mouse_down, exec, ags -b hyprland -r 'indicator.workspace()'
    bind = ${modifier}, mouse_up, workspace, m-1
    bind = ${modifier}, mouse_up, exec, ags -b hyprland -r 'indicator.workspace()'

    # Move/resize windows with modifier + LMB/RMB and dragging
    bindm = ${modifier}, mouse:272, movewindow
    bindm = ${modifier}, mouse:273, resizewindow

    # Volume keys
    bindle = , XF86AudioRaiseVolume, exec, ${volumehelper} --limit "100" --increase "2"
    bindle = , XF86AudioLowerVolume, exec, ${volumehelper} --limit "100" --decrease "2"
    bindl = , XF86AudioMute, exec, ${pactl} set-sink-mute @DEFAULT_SINK@ toggle && ${volumehelper}
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
    # Capture all visible windows
    bind = ALT, Print, exec, ${grimblast} save screen - | ${swappy} -f -
    # Capture the active window
    bind = CTRL, Print, exec, ${grimblast} save active - | ${swappy} -f -
    # Capture an area selection
    bind = SHIFT, Print, exec, ${grimblast} save area - | ${swappy} -f -

    # Passthrough submap
    bind = ${modifier}, Pause, submap, passthrough_submap
    submap = passthrough_supmap
    bind = ${modifier}, Pause, submap, reset
    submap = reset

    # Run submap
    bind = ${modifier}, R, submap, run_submap
    submap = run_submap
    bind = , D, exec, ${gtk-launch} discord.desktop
    bind = , D, submap, reset
    bind = , F, exec, ${fileBrowser}
    bind = , F, submap, reset
    bind = , M, exec, ${gtk-launch} electron-mail.desktop
    bind = , M, submap, reset
    bind = , P, exec, ${gtk-launch} pavucontrol.desktop
    bind = , P, submap, reset
    bind = , S, exec, ${gtk-launch} steam.desktop
    bind = , S, submap, reset
    bind = , Escape, submap, reset
    submap = reset
  '';
}
