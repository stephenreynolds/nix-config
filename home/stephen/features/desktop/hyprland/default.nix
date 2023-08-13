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
        "SUPER,space,exec,${wofi} -S drun -x 10 -y 10 -W 25% -H 60%"
        "SUPER,d,exec,${wofi} -S run"
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
    "WLR_NO_HARDWARE_CURSORS" = 1;
  };
}
