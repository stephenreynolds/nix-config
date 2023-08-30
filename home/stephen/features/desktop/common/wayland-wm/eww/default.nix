{ config, lib, inputs, pkgs, ... }:
let
  dependencies = with pkgs; [
    config.programs.eww.package
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
    json-notification-daemon
  ];
in
{
  programs.eww = {
    enable = true;
    package = inputs.eww.packages.${pkgs.system}.eww-wayland;
    configDir = ./config;
  };

  systemd.user.services.eww = {
    Unit = {
      Description = "ElKowars wacky widgets";
      PartOf = [ "graphical-session.target" ];
    };

    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      ExecStart = "${config.programs.eww.package}/bin/eww daemon --no-daemonize";
      ExecStartPost = "${config.xdg.configHome}/eww/scripts/launch";
      ExecStop = "${config.programs.eww.package}/bin/eww kill";
      Restart = "on-failure";
      Environment = "PATH=/run/wrapper/bin:${lib.makeBinPath dependencies}";
      WorkingDirectory = "${config.xdg.configHome}/eww";
    };
  };
}
