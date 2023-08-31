{ lib, config, pkgs, inputs, ... }: {
  imports = [
    ../common
    ../common/wayland-wm

    ./tty-init.nix
    ./systemd-fixes.nix

    inputs.hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    recommendedEnvironment = true;
    extraConfig = let
      modifier = "SUPER";
      playerctl = "${config.services.playerctld.package}/bin/playerctl";
      wofi = "${config.programs.wofi.package}/bin/wofi";

      pactl = "${pkgs.pulseaudio}/bin/pactl";

      gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
      xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
      defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

      terminal = config.home.sessionVariables.TERMINAL;
      browser = defaultApp "x-scheme-handler/https";
      fileBrowser = defaultApp "inode/directory";
    in lib.concatStrings [
    ''
      # Monitors
      monitor = DP-1, 1920x1080@60, 0x0, 1
      monitor = DP-2, 1920x1080@60, 1920x0, 1
      monitor = HDMI-A-1, 1920x1080@60, 3840x0, 1
    ''
    ''
      # Workspaces
      workspace = 1, monitor:DP-1, default:true
      workspace = 2, monitor:DP-2, default:true
      workspace = 3, monitor:HDMI-A-1, default:true
      workspace = 4, monitor:DP-1
      workspace = 5, monitor:DP-2
      workspace = 6, monitor:HDMI-A-1
      workspace = 7, monitor:DP-1
      workspace = 8, monitor:DP-2
      workspace = 9, monitor:HDMI-A-1
    ''
    ''
      input {
        kb_layout = us

        follow_mouse = 2
        float_switch_override_focus = 2

        numlock_by_default = true
      }
    ''
    ''
      general {
        gaps_in = 5
        gaps_out = 10

        border_size = 1
        col.active_border = 0xff${config.colorscheme.colors.base0C}
        col.inactive_border = 0xff${config.colorscheme.colors.base02}
        col.group_border = 0xff${config.colorscheme.colors.base04}
        col.group_border_active = 0xff${config.colorscheme.colors.base0B}

        layout = master

        resize_on_border = true

        cursor_inactive_timeout = 10
      }
    ''
    ''
      decoration {
        rounding = 5

        blur {
          enabled = true
          size = 8
          passes = 2
          new_optimizations = true
          xray = false
          noise = 0.0117
          special = false
        }

        drop_shadow = true
        shadow_range = 12
        shadow_offset = 3 3
        col.shadow = 0x44000000
        col.shadow_inactive = 0x66000000
      }
    ''
    ''
      animations {
        enabled = true

        bezier = overshot, 0.05, 0.9, 0.1, 1.1

        animation = windows, 1, 2, overshot
        animation = windowsOut, 1, 2, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 2, default
        animation = workspaces, 1, 2, default
        animation = specialWorkspace, 1, 2, default, slidevert
      }
    ''
    ''
      dwindle {
        pseudotile = true
        preserve_split = true
        no_gaps_when_only = 1
      }
    ''
    ''
      master {
        mfact = 0.55
        new_is_master = true
        new_on_top = true
        orientation = center
        inherit_fullscreen = true
        no_gaps_when_only = 1
      }
    ''
    ''
      binds {
        allow_workspace_cycles = true
      }
    ''
    ''
      misc {
        focus_on_activate = true
        mouse_move_enables_dpms = true
        key_press_enables_dpms = true
        allow_session_lock_restore = true
        render_titles_in_groupbar = false
        moveintogroup_lock_check = true
      }
    ''
    ''
      xwayland {
        force_zero_scaling = true
      }
    ''
    ''
      blurls = notifications
      layerrule = ignorezero, notifications
      blurls = rofi
      layerrule = ignorezero, rofi
      blurls = gtk-layer-shell
      layerrule = ignorezero, gtk-layer-shell
      blurls = eww
      layerrule = ignorezero, eww
    ''
    ''
      windowrule = dimaround, ^(wofi)$
      windowrule = nofullscreenrequest, ^(steam)$
      windowrule = nofullscreenrequest, ^(tasty.javafx.launcher.LauncherFxApp)$

      ## Rules: polkit agent
      windowrulev2 = float,class:^(lxqt-policykit-agent)$
      windowrulev2 = center,class:^(lxqt-policykit-agent)$
      windowrulev2 = float,class:^(polkit-gnome-authentication-agent-1)$
      windowrulev2 = center,class:^(polkit-gnome-authentication-agent-1)$
      windowrulev2 = float,class:^(polkit-mate-authentication-agent-1)$
      windowrulev2 = center,class:^(polkit-mate-authentication-agent-1)$

      ## Rules: browser
      windowrulev2 = idleinhibit fullscreen,class:^(Chromium-browser)$
      windowrulev2 = idleinhibit fullscreen,class:^(Brave-browser)$
      windowrulev2 = idleinhibit fullscreen,class:^(firefox)$
      windowrulev2 = idleinhibit fullscreen,class:^(microsoft-edge)$
      windowrulev2 = float,title:^(Firefox - Sharing Indicator)$

      ## Rules: picture-in-picture
      windowrulev2 = float,title:^(Picture-in-Picture)$
      windowrulev2 = pin,title:^(Picture-in-Picture)$
      windowrulev2 = noborder,title:^(Picture-in-Picture)$
      windowrulev2 = noshadow,title:^(Picture-in-Picture)$

      ## Rules: pavucontrol
      windowrulev2 = float,class:^(pavucontrol)$
      windowrulev2 = center,class:^(pavucontrol)$
      windowrulev2 = float,class:^(pavucontrol-qt)$
      windowrulev2 = center,class:^(pavucontrol-qt)$

      ## Rules: piavpn
      windowrulev2 = nofullscreenrequest,class:^(piavpn)$

      ## Rules: onedrivegui
      windowrulev2 = float, title:^(OneDriveGUI)$
      windowrulev2 = move 78% 22%, title:^(OneDriveGUI)$
    ''
    ''
      bind = ${modifier}, T, exec, ${terminal}
      bind = ${modifier}, W, exec, ${browser}
      bind = ${modifier}, C, killactive
      bind = ${modifier}, V, fullscreen, 1
      bind = ${modifier} SHIFT, V, fullscreen, 0
      bind = ${modifier}, F, togglefloating
      bind = ${modifier} SHIFT, F, pin
      bind = ${modifier}, Space, exec, pkill ${wofi} || ${wofi} --show drun --normal-window --allow-images
      bind = ${modifier}, U, pseudo, # dwindle
      bind = ${modifier}, J, togglesplit, # dwindle
      bind = ${modifier}, S, exec, hyprctl dispatch cyclenext && hyprctl dispatch layoutmsg swapwithmaster # master
      bind = ${modifier}, L, layoutmsg, orientationnext
      bind = ${modifier} SHIFT, L, layoutmsg, orientationprev

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
      bind = ${modifier} SHIFT, down,movewindow, d

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

      # Move window through workspaces
      bind = ${modifier}, 8, workspace, r-1
      bind = ${modifier}, 9, workspace, r+1
      bind = ${modifier} SHIFT, 8, movetoworkspace, r-1
      bind = ${modifier} SHIFT, 9, movetoworkspace, r+1

      # Bind workspaces
      bind = ${modifier}, 1, workspace, 1
      bind = ${modifier}, 2, workspace, 2
      bind = ${modifier}, 3, workspace, 3
      bind = ${modifier}, 4, workspace, 4
      bind = ${modifier}, 5, workspace, 5
      bind = ${modifier}, 6, workspace, 6
      bind = ${modifier}, 7, workspace, 7
      bind = ${modifier}, 8, workspace, 8
      bind = ${modifier}, 9, workspace, 9

      # Move window to workspace
      bind = ${modifier} SHIFT, 1, movetoworkspace, 1
      bind = ${modifier} SHIFT, 2, movetoworkspace, 2
      bind = ${modifier} SHIFT, 3, movetoworkspace, 3
      bind = ${modifier} SHIFT, 4, movetoworkspace, 4
      bind = ${modifier} SHIFT, 5, movetoworkspace, 5
      bind = ${modifier} SHIFT, 6, movetoworkspace, 6
      bind = ${modifier} SHIFT, 7, movetoworkspace, 7
      bind = ${modifier} SHIFT, 8, movetoworkspace, 8
      bind = ${modifier} SHIFT, 9, movetoworkspace, 9

      bind = ${modifier} ALT, 7, changegroupactive

      # Special workspaces
      bind = ${modifier} SHIFT, 0, movetoworkspace, special
      bind = ${modifier}, 0, togglespecialworkspace,

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
      bind = , Print, exec, grimblast save output - | swappy -f -
      # Capture the active window
      bind = ALT, Print, exec, grimblast save active - | swappy -f -
      # Capture the active window
      bind = CTRL, Print, exec, grimblast save area - | swappy -f -

      # Passthrough submap
      bind = ${modifier}, Pause, submap, passthrough_submap
      submap = passthrough_supmap
      bind = ${modifier}, Pause, submap, reset
      submap = reset

      # Run submap
      bind = ${modifier}, R, submap, run_submap
      submap = run_submap
      bind = , D, exec, discord
      bind = , D, submap, reset
      bind = , F, exec, ${fileBrowser}
      bind = , F, submap, reset
      bind = , M, exec, mailspring
      bind = , M, submap, reset
      bind = , P, exec, pavucontrol
      bind = , P, submap, reset
      bind = , S, exec, steam
      bind = , S, submap, reset
      bind = , Escape, submap, reset
      submap = reset

      # Global keybinds
      bind = ${modifier} CTRL, E, pass, ^(ClickUp)$
      bind = ${modifier} CTRL, N, pass, ^(ClickUp)$
    ''];
  };

  home.sessionVariables = {
    "LIBVA_DRIVER_NAME" = "nvidia";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "WLR_NO_HARDWARE_CURSORS" = 1;
  };
}
