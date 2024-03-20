{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOptionDefault;
  cfg = config.modules.desktop.i3;
in {
  options.modules.desktop.i3 = {
    enable = mkEnableOption "Whether to enable i3 window manager";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      displayManager.defaultSession = "none+i3";
      windowManager.i3.enable = true;
    };

    hm.xsession.windowManager.i3 = {
      enable = true;
      config = {
        bars = [{
          statusCommand = "${pkgs.i3status}/bin/i3status";
          trayOutput = "primary";
        }];
        fonts = {
          names = [ "monospace" ];
          size = 15.0;
        };
        keybindings = let
          modifier = config.hm.xsession.windowManager.i3.config.modifier;
          pactl = "${pkgs.pulseaudio}/bin/pactl";
          xbacklight = "${pkgs.xorg.xbacklight}/bin/xbacklight";
        in mkOptionDefault {
          # Change focus
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          # Move focused window
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          # Split in horizontal/vertical orientation
          "${modifier}+z" = "split h";
          "${modifier}+v" = "split v";

          # Enter fullscreen mode for the focused container
          "${modifier}+f" = "fullscreen toggle";

          # Change container layout
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          # Toggle tiling/floating
          "${modifier}+Shift+space" = "floating toggle";

          # Focus the parent container
          "${modifier}+a" = "focus parent";

          # Focus the child container
          "${modifier}+d" = "focus child";

          # Switch to workspace
          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";
          "${modifier}+0" = "workspace 0";

          # Move focused container to workspace
          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";
          "${modifier}+Shift+0" = "move container to workspace 0";

          # Reload the configuration file
          "${modifier}+Shift+c" = "reload";

          # Restart i3 in-place
          "${modifier}+Shift+r" = "restart";

          # Exit i3
          "${modifier}+Shift+e" = ''
            exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"'';

          "${modifier}+r" = "mode 'resize'";

          "XF86AudioRaiseVolume" =
            "exec --no-startup-id ${pactl} set-sink-volume 0 +5%";
          "XF86AudioLowerVolume" =
            "exec --no-startup-id ${pactl} set-sink-volume 0 -5%";
          "XF86AudioMute" =
            "exec --no-startup-id ${pactl} set-sink-mute 0 toggle";

          "XF86MonBrightnessUp" = "exec ${xbacklight} -inc 20";
          "XF86MonBrightnessDown" = "exec ${xbacklight} -dec 20";

          "${modifier}+m" = "move workspace to output left";

          "${modifier}+Shift+period" = "exec systemctl suspend";
        };
        modes.resize = {
          h = "resize shrink width 10 px or 10 ppt";
          j = "resize grow height 10 px or 10 ppt";
          k = "resize shrink height 10 px or 10 ppt";
          l = "resize grow width 10 px or 10 ppt";

          Left = "resize shrink width 10 px or 10 ppt";
          Down = "resize grow height 10 px or 10 ppt";
          Up = "resize shrink height 10 px or 10 ppt";
          Right = "resize grow width 10 px or 10 ppt";

          Return = "mode 'default'";
          Escape = "mode 'default'";
        };
        startup = [{
          command = "nm-applet";
          notification = false;
        }];
        window.commands = [
          {
            command = "border pixel 2";
            criteria.class = "^.*";
          }
          {
            command = "client.focused #77dd77 #285577 #ffffff #2e9ef4 #285577";
            criteria.class = "^.*";
          }
        ];
      };
    };

    hm.programs.i3status = {
      enable = true;
      enableDefault = false;
      general = {
        colors = true;
        interval = 5;
      };
      modules = {
        "disk /" = {
          position = 1;
          settings.format = "%avail";
        };
        "battery all" = {
          position = 2;
          settings.format = "%status %percentage %remaining";
        };
        "load" = {
          position = 3;
          settings.format = "%1min";
        };
        "tztime local" = {
          position = 4;
          settings.format = "%Y-%m-%d %H:%M:%S";
        };
      };
    };
  };
}
