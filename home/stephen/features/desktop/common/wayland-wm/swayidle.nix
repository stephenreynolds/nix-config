{ pkgs, lib, config, ... }:

let
  swaylock = "${config.programs.swaylock.package}/bin/swaylock";
  pgrep = "${pkgs.procps}/bin/pgrep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";

  isLocked = "${pgrep} -x ${swaylock}";
  lockTime = 10 * 60; # 10 min

  # Make two timeouts: onefor when the screen is not locked and one for when it is.
  afterLockTimeout = { timeout, command, resumeCommand ? null }: [
    { timeout = lockTime + timeout; inherit command resumeCommand; }
    { command = "${isLocked} && ${command}"; inherit resumeCommand timeout; }
  ];
in
{
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    timeouts =
      # Lock screen
      [{
        timeout = lockTime;
        command = "${swaylock} -S --daemonize";
      }] ++
      # Mute mic
      (afterLockTimeout {
        timeout = 10;
        command = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
        resumeCommand = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";
      }) ++
      # Turn off displays
      (lib.optionals config.wayland.windowManager.hyprland.enable (afterLockTimeout {
        timeout = 40;
        command = "${hyprctl} dispatch dpms off";
        resumeCommand = "${hyprctl} dispatch dpms on";
      }));
  };
}
