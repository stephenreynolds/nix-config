{ pkgs, config, lib, ... }:
let
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or  [ ]) ++ [ "-Dexperimental=true" ];
    });
    systemd.enable = true;
    settings = {
      primary = {
        mode = "dock";
        layer = "top";
        height = 28;
        position = "top";
        output = builtins.map (m:  m.name) (builtins.filter (m: !m.noBar) config.monitors);
        modules-left = (lib.optionals config.wayland.windowManager.hyprland.enable [
          "wlr/workspaces"
        ]);
        modules-center = [
        ];
        modules-right = [
          "tray"
          "clock"
        ];

        "wlr/workspaces" = {
          on-click = "activate";
        };
        clock = {
          format = "{:%a %b %d  %I:%M %p}";
          timezones = [
            "America/Detroit"
            "Asia/Tokyo"
          ];
          tooltip = true;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b>{}</b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        tray = {
          spacing = 10;
          reverse-direction = true;
        };
        cpu = {
          interval = 1;
          format = " {}%";
          max-length = 10;
          on-clock = "kitty -e btop";
        };
        memory = {
          interval = 5;
          format = " {}%";
          format-alt = " {used}G";
          states = {
            warning = 16;
            critical = 24;
          };
        };
        network = {
          format-wifi = "直";
          format-ethernet = "";
          on-click = "kitty -e nmtui";
          format-disconnected = "睊";
        };
      };
      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "   0%";
        format-icons = {
          headphone = "󰋋";
          headset = "󰋎";
          portable = "";
          default = [ "" "" "" ];
        };
        on-click = pavucontrol;
      };
      network = {
        interval = 3;
        format-wifi = "   {essid}";
        format-ethernet = "󰈁 Connected";
        format-disconnected = "";
        tooltip-format = ''
          {ifname}
          {ipaddr}/{cidr}
          Up: {bandwidthUpBits}
          Down: {bandwidthDownBits}'';
        on-click = "";
      };
    };
    style = ''
      * {
        font-family: ${config.fontProfiles.regular.family}, ${config.fontProfiles.monospace.family};;
        font-size: 10pt;
        padding: 0 8px;
        background-color: #000;
      }

      .modules-right {
        margin-right: -15px;
      }

      .modules-left {
        margin-left: -15px;
      }

      window#waybar.top {
        opacity: 0.95;
        padding: 0;
        border-radius: 10px;
      }
      window#waybar.bottom {
        opacity: 0.90;
        border-radius: 10px;
      }

      window#waybar {
      }

      #workspaces button {
        margin: 4px;
      }
      #workspaces button.hidden {
      }
      #workspaces button.focused,
      #workspaces button.active {
      }

      #clock {
        padding-left: 15px;
        padding-right: 15px;
        margin-top: 0;
        margin-bottom: 0;
        border-radius: 10px;
      }

      #tray {
      }
    '';
  };
}
