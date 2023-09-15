{ config, lib, inputs, pkgs, ... }:
let
  inherit (config.colorscheme) colors;
in
{
  programs.eww = {
    enable = true;
    package = inputs.eww.packages.${pkgs.system}.eww-wayland;
    configDir = inputs.eww-config;
  };

  systemd.user.services.eww = {
    Unit = {
      Description = "ElKowars wacky widgets";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      ExecStart = "${config.programs.eww.package}/bin/eww daemon --no-daemonize";
      ExecStartPost = "${inputs.eww-config}/scripts/launch";
      ExecStop = "${config.programs.eww.package}/bin/eww kill";
      Restart = "on-failure";
      Environment =
        let
          dependencies = with pkgs; [
            config.programs.eww.package
            config.programs.wofi.package
            config.programs.kitty.package
            coreutils
            bash
            gawk
            gnugrep
            gnused
            socat
            jq
            hyprland
            networkmanager
            pulseaudio
            pamixer
            dbus
            python3
            procps
            iputils
            json-notification-daemon
          ];
        in
        "PATH=/run/wrapper/bin:${lib.makeBinPath dependencies}";
      WorkingDirectory = "${config.xdg.configHome}/eww";
    };
  };

  xdg.configFile."eww-colors" = {
    target = "base16.scss";
    text = ''
      $base16: (
        "bg-layer-1": #${colors.base00},
        "bg-layer-2": #${colors.base01},
        "bg-layer-3": #${colors.base00},
        "bg-layer-4": #${colors.base02},
        "bg-layer-5": #${colors.base03},
        "text": #${colors.base05},
        "muted": #${colors.base04},
        "accent-1": #${colors.base08},
        "accent-2": #${colors.base09},
        "accent-3": #${colors.base0E},
        "accent-4": #${colors.base0B},
        "accent-5": #${colors.base0D},
        "accent-6": #${colors.base07},
        "bg-opacity": 1
      );
    '';
  };
}
