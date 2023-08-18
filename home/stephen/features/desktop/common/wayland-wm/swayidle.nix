{ pkgs, lib, config, ... }:

let
  swaylock = "${config.programs.swaylock.package}/bin/swaylock";
  pgrep = "${pkgs.procps}/bin/pgrep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";

  isLocked = "${pgrep} -x ${swaylock}";
  lockTime = 60 * 10; # 10 min
  muteTime = 5; # 5 sec
  screenOffTime = 30; # 30 sec
  suspendTime = 60 * 60; # 1 hour

  # Make two timeouts: one for when the screen is not locked and one for when it is.
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
        command = "${swaylock} --grace 10 --fade-in 1";
      }] ++
      # Mute mic
      (afterLockTimeout {
        timeout = muteTime;
        command = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
        resumeCommand = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";
      }) ++
      # Turn off displays
      (lib.optionals config.wayland.windowManager.hyprland.enable (afterLockTimeout {
        timeout = screenOffTime;
        command = "${hyprctl} dispatch dpms off";
        resumeCommand = "${hyprctl} dispatch dpms on";
      })) ++
      # Suspend
      (afterLockTimeout {
        timeout = suspendTime;
        command = "${hyprctl} dispatch dpms on; sleep 1; systemctl suspend";
      });
    events = [
      # Before sleep
      {
        event = "before-sleep";
        command = "${swaylock}";
      }
      # Lock
      {
        event = "lock";
        command = "${swaylock}";
      }
      # Unlock
      {
        event = "unlock";
        command = "pkill -xu '$USER' -SIGUSR1 ${swaylock}";
      }
    ];
  };
}
