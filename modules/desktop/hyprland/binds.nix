{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.modules.desktop.hyprland;

  gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
  xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
  defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";
  ags = "${inputs.ags.packages.${pkgs.system}.default}/bin/ags -b hyprland";
in
lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.keyBinds = let
    modifier = "SUPER";

    mouseLMB = "mouse:272";  
    mouseRMB = "mouse:273";  

    exec = {
      terminal = config.hm.home.sessionVariables.TERMINAL;
      browser = defaultApp "x-scheme-handler/https";
      privateBrowser = "firefox --private-window";
      fileBrowser = defaultApp "inode/directory";

      killandswitch = ./scripts/kill_and_switch.nix;
      togglelayout = ./scripts/toggle_layout.nix;
      focusempty = ./scripts/toggle_layout.nix;
      movetoempty = ./scripts/move_to_empty.nix;
      volumehelper = ./scripts/volume_helper.nix;

      showWorkspaceIndicator = "${ags} -b hyprland -r 'indicator.workspace()'";

      pactl = "${pkgs.pulseaudio}/bin/pactl";
      grimblast = "${inputs.hyprland-contrib.packages.${pkgs.system}.grimblast}/bin/grimblast";
      playerctl = "${config.hm.services.playerctld.package}/bin/playerctl";
      swappy = lib.getExe pkgs.swappy;
    };
  in lib.mkMerge [
    # Launch programs
    {
      bind."${modifier}, T" = "exec, ${exec.terminal}";
      bind."${modifier}, W" = "exec, ${exec.browser}";
      bind."${modifier} SHIFT, W" = "exec, ${exec.privateBrowser}";
    }
    # Kill the active window 
    {
      bind."${modifier}, C" = "exec, ${exec.killandswitch}";
    }
    # Open launcher
    {
      bind."${modifier}, Space" = "exec, ${ags} -t overview";
    }
    # Cycle through windows
    {
      bind."${modifier}, Tab" = "cyclenext";
    }
    # Window mode
    {
      bind."${modifier}, V" = "fullscreen, 1";
      bind."${modifier} SHIFT, V" = "fullscreen, 0";
      bind."${modifier}, F" = "togglefloating";
      bind."${modifier} SHIFT, F" = "pin";
      bind."${modifier} ALT, F" = "workspaceopt, allfloat";
    }
    # Toggle layout
    {
      bind."${modifier} SHIFT, L" = "exec, ${exec.togglelayout}";
    }
    # Dwindle layout
    {
      bind."${modifier}, U" = "pseudo";
      bind."${modifier}, J" = "togglesplit";
    }
    # Master layout
    {
      bind."${modifier}, S" = "cyclenext";
      bind."${modifier}, S" = "layoutmsg, swapwithmaster";
      bind."${modifier}, L" = "layoutmsg, orientationcycle center left";
    }
    # Focus last window
    {
      bind."${modifier}, D" = "focuscurrentorlast";
    }
    # Move focus with {modifier} + arrow keys
    {
      bind."${modifier}, left" = "movefocus, l";
      bind."${modifier}, right" = "movefocus, r";
      bind."${modifier}, up" = "movefocus, u";
      bind."${modifier}, down" = "movefocus, d";
    }
    # Move window with {modifier} + Shift + arrow keys
    {
      bind."${modifier} SHIFT, left" = "movewindow, l";
      bind."${modifier} SHIFT, right" = "movewindow, r";
      bind."${modifier} SHIFT, up" = "movewindow, u";
      bind."${modifier} SHIFT, down" = "movewindow, d";
    }
    # Resize window with {modifier} + Ctrl + arrow keys
    {
      binde."${modifier} CTRL, left" = "resizeactive, -10 0";
      binde."${modifier} CTRL, right" = "resizeactive, 10 0";
      binde."${modifier} CTRL, up" = "resizeactive, 0 -10";
      binde."${modifier} CTRL, down" = "resizeactive, 0 10";
    }
    # Group window
    {
      bind."${modifier}, G" = "togglegroup";
      bind."${modifier} CTRL, G" = "moveoutofgroup";
      bind."${modifier} ALT, G" = "lockactivegroup, toggle";
      bind."${modifier} ALT, left" = "moveintogroup, l";
      bind."${modifier} ALT, right" = "moveintogroup, r";
      bind."${modifier} ALT, up" = "moveintogroup, u";
      bind."${modifier} ALT, down" = "moveintogroup, d";
    }
    # Switch to next window in group
    {
      bind."${modifier}, 8" = "changegroupactive";
      bind."${modifier}, 7" = "movegroupwindow, b";
      bind."${modifier}, 9" = "movegroupwindow, f";
    }
    # Workspaces
    {
      # Focus previous workspace on monitor
      bind."${modifier}, 5" = "workspace, m-1";
      bind."${modifier}, 5" = "exec, ${exec.showWorkspaceIndicator}";

      # Focus next workspace on monitor
      bind."${modifier}, 6" = "workspace, m+1";
      bind."${modifier}, 6" = "exec, ${exec.showWorkspaceIndicator}";

      # Move window to previous workspace on monitor
      bind."${modifier} SHIFT, 5" = "movetoworkspace, m-1";
      bind."${modifier} SHIFT, 5" = "exec, ${exec.showWorkspaceIndicator}";

      # Move window to next workspace on monitor
      bind."${modifier} SHIFT, 6" = "movetoworkspace, m+1";
      bind."${modifier} SHIFT, 6" = "exec, ${exec.showWorkspaceIndicator}";

      # Move window to previous workspace on monitor, inclusing empty
      bind."${modifier} CTRL, 5" = "movetoworkspace, r-1";
      bind."${modifier} CTRL, 5" = "exec, ${exec.showWorkspaceIndicator}";

      # Focus next empty workspace on monitor
      bind."${modifier}, 4" = "exec, ${exec.focusempty}";
      bind."${modifier}, 4" = "exec, ${exec.showWorkspaceIndicator}";
      bind."${modifier} SHIFT, 4" = "exec, ${exec.movetoempty}";
      bind."${modifier} SHIFT, 4" = "exec, ${exec.showWorkspaceIndicator}";

      # Focus previous workspace
      bind."${modifier}, 3" = "workspace, previous";
      bind."${modifier}, 3" = "exec, ${exec.showWorkspaceIndicator}";

      # Move window to previous workspace
      bind."${modifier} SHIFT, 3" = "movetoworkspace, previous";
      bind."${modifier} SHIFT, 3" = "exec, ${exec.showWorkspaceIndicator}";
    }
    # Special workspace
    {
      bind."${modifier}, 0" = "togglespecialworkspace";
      bind."${modifier} SHIFT, 0" = "movetoworkspace, special";
    }
    # Monitors
    {
      # Focus monitor
      bind."${modifier}, 1" = "focusmonitor, l";
      bind."${modifier}, 2" = "focusmonitor, r";

      # Move window to monitor
      bind."${modifier} SHIFT, 1" = "movewindow, mon:l";
      bind."${modifier} SHIFT, 2" = "movewindow, mon:r";

      # Move workspace to monitor
      bind."${modifier} CTRL, 1" = "movecurrentworkspacetomonitor, l";
      bind."${modifier} CTRL, 2" = "movecurrentworkspacetomonitor, r";
    }
    # Mouse controls
    {
      # Scroll through existing workspaces with {modifier} + scroll
      bind."${modifier}, mouse_up" = "workspace, m-1";
      bind."${modifier}, mouse_up" = "exec, ${exec.showWorkspaceIndicator}";
      bind."${modifier}, mouse_down" = "workspace, m+1";
      bind."${modifier}, mouse_down" = "exec, ${exec.showWorkspaceIndicator}";

      # Move/resize windows with modifier + LMB/RMB and dragging
      bindm."${modifier}, ${mouseLMB}" = "movewindow";
      bindm."${modifier}, ${mouseRMB}" = "resizewindow";
    }
    # Volume keys
    {
      bindle."${modifier}, XF86AudioRaiseVolume" = "exec, ${exec.volumehelper} --limit 100 --increase 2";
      bindle."${modifier}, XF86AudioLowerVolume" = "exec, ${exec.volumehelper} --limit 100 --decrease 2";
      bindl."${modifier}, XF86AudioMute" = "exec, ${exec.pactl} set-sink-mute @DEFAULT_SINK@ toggle && ${exec.volumehelper}";
      bindl."${modifier}, XF86AudioMicMute" = "exec, ${exec.pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
    }
    # Media keys
    {
      bind."${modifier}, XF86AudioForward" = "exec, ${exec.playerctl} position +10";
      bind."${modifier}, XF86AudioRewind" = "exec, ${exec.playerctl} position -10";
      bind."${modifier}, XF86AudioNext" = "exec, ${exec.playerctl} next";
      bind."${modifier}, XF86AudioPrev" = "exec, ${exec.playerctl} previous";
      bind."${modifier}, XF86AudioPause" = "exec, ${exec.playerctl} pause";
      bindl."${modifier}, XF86AudioPlay" = "exec, ${exec.playerctl} play-pause";
      bindl."${modifier}, XF86AudioStop" = "exec, ${exec.playerctl} stop";
    }
    # Screenshots
    {
      # Capture the active output
      bind."${modifier}, Print" = "exec, ${exec.grimblast} save output - | ${exec.swappy} -f -";
      # Capture all visible outputs
      bind."${modifier} ALT, Print" = "exec, ${exec.grimblast} save screen - | ${exec.swappy} -f -";
      # Capture the active window
      bind."${modifier} SHIFT, Print" = "exec, ${exec.grimblast} save active - | ${exec.swappy} -f -";
      # Capture an area selection
      bind."${modifier} CTRL, Print" = "exec, ${exec.grimblast} save area - | ${exec.swappy} -f -";
    }
    # Passthrough submap
    {
      bind."${modifier}, Pause" = "submap, passthrough";
      submap.passthrough = { bind."${modifier}, Pause" = "submap, reset"; };
    }
    # Run submap
    {
      bind."${modifier}, R" = "submap, run";
      submap.run = {
        bind."${modifier}, D" = "exec, ${gtk-launch} discord.desktop";
        bind."${modifier}, F" = "exec, ${exec.fileBrowser}";
        bind."${modifier}, M" = "exec, ${gtk-launch} electron-mail.desktop";
        bind."${modifier}, P" = "exec, ${gtk-launch} pavucontrol.desktop";
        bind."${modifier}, S" = "exec, ${gtk-launch} steam.desktop";
        bind."${modifier}, Escape" = "submap, reset";
      };
    }
  ];
}
