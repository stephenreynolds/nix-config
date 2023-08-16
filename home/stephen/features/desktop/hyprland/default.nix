{ lib, config, pkgs, ... }: {
  imports = [
    ../common
    ../common/wayland-wm

    ./tty-init.nix
    ./basic-binds.nix
    ./systemd-fixes.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    settings = {
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        layout = "master";
        resize_on_border = true;
        cursor_inactive_timeout = 10;
        "col.active_border" = "rgb(bd93f9)";
        "col.inactive_border" = "rgba(44475aaa)";
        "col.group_border" = "rgba(282a36dd)";
        "col.group_border_active" = "rgb(bd93f9)";
      };
      decoration = {
        active_opacity = 0.94;
        inactive_opacity = 0.84;
        fullscreen_opacity = 1.0;
        rounding = 5;
        blur = true;
        blur_size = 5;
        blur_passes = 3;
        blur_new_optimizations = true;
        blur_ignore_opacity = true;
        drop_shadow = true;
        shadow_range = 12;
        shadow_offset = "3 3";
        "col.shadow" = "0x44000000";
        "col.shadow_inactive" = "0x66000000";
      };
      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 2, myBezier"
          "windowsOut, 1, 2, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 2, default"
          "workspaces, 1, 2, default"
          "specialWorkspace, 1, 2, default, slidevert"
        ];
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        no_gaps_when_only = true;
      };
      master = {
        mfact = 0.5;
        new_is_master = true;
        new_on_top = true;
        orientation = "left";
        inherit_fullscreen = true;
        no_gaps_when_only = 1;
      };
      device = {
        logitech-g502-hero-gaming-mouse = {
          sensitivity = 0;
        };
      };
      input = {
        kb_layout = "us";
        follow_mouse = 2;
        float_switch_override_focus = 2;
        numlock_by_default = true;
      };
      binds = {
        allow_workspace_cycles = true;
      };
      misc = {
        focus_on_activate = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        allow_session_lock_restore = true;
        render_titles_in_groupbar = false;
      };
      xwayland = {
        force_zero_scaling = true;
      };
      windowrulev2 = [
        # Wofi
        "dimaround, class:^(wofi)$"

        # Browser
        "opaque, class:^(firefox)$"
        "idleinhibit fullscreen, class:^(firefox)$"
        "float, title:^(Firefox - Sharing Indicator)$"

        # picture-in-picture
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "noborder, title:^(Picture-in-Picture)$"
        "noshadow, title:^(Picture-in-Picture)$"

        # pavucontrol
        "float, class:^(pavucontrol)$"
        "center, class:^(pavucontrol)$"
      ];
      bind = let
        swaylock = "${config.programs.swaylock.package}/bin/swaylock";
        playerctl = "${config.services.playerctld.package}/bin/playerctl";
        playerctld = "${config.services.playerctld.package}/bin/playerctld";
        makoctl = "${config.services.mako.package}/bin/makoctl";
        wofi = "${config.programs.wofi.package}/bin/wofi";

        pactl = "${pkgs.pulseaudio}/bin/pactl";

        gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
        xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
        defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

        terminal = config.home.sessionVariables.TERMINAL;
        browser = defaultApp "x-scheme-handler/https";
      in [
        "SUPER, T, exec, ${terminal}"
        "SUPER, W, exec, ${browser}"

        # Volume
        ",XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
        ",XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
        ",XF86AudioMute,exec,${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
        "SHIFT,XF86AudioMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
        ",XF86AudioMicMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
      ] ++

      (lib.optionals config.services.playerctld.enable [
        # Media control
        ",XF86AudioNext,exec,${playerctl} next"
        ",XF86AudioPrev,exec,${playerctl} previous"
        ",XF86AudioPlay,exec,${playerctl} play-pause"
        ",XF86AudioStop,exec,${playerctl} stop"
        "ALT,XF86AudioNext,exec,${playerctld} shift"
        "ALT,XF86AudioPrev,exec,${playerctld} unshift"
        "ALT,XF86AudioPlay,exec,systemctl --user restart playerctld"
      ]) ++
      # Screen lock
      (lib.optionals config.programs.swaylock.enable [
        ",XF86Launch5,exec,${swaylock} -S"
        ",XF86Launch4,exec,${swaylock} -S"
        "SUPER,backspace,exec,${swaylock} -S"
      ]) ++
      # Notification manager
      (lib.optionals config.services.mako.enable [
        "SUPER,w,exec,${makoctl} dismiss"
      ]) ++

      # Launcher
      (lib.optionals config.programs.wofi.enable [
        "SUPER,space,exec,${wofi} -S drun -x 10 -y 10 -W 25% -H 60% --normal-window"
        "SUPER,d,exec,${wofi} -S run --normal-window"
      ]);

      monitor = map (m: let
        resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
        position = "${toString m.x}x${toString m.y}";
      in
        "${m.name}, ${if m.enabled then "${resolution}, ${position}, 1" else "disable"}"
      ) (config.monitors);

      workspace = map (m:
        "${m.name}, ${m.workspace}"
      ) (lib.filter (m: m.enabled && m.workspace != null) config.monitors);
    };
    extraConfig = ''
      # Passthrough
      bind = SUPER, P, submap, passthrough
      submap = passthrough
      bind = SUPER, P, submap, reset
      submap = reset
    '';
  };

  home.sessionVariables = {
    "LIBVA_DRIVER_NAME" = "nvidia";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "WLR_NO_HARDWARE_CURSORS" = 1;
  };
}
