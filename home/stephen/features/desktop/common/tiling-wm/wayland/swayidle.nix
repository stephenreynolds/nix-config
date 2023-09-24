{ pkgs, lib, config, ... }:

let
  gtklock = "${config.programs.gtklock.package}/bin/gtklock";
  pgrep = "${pkgs.procps}/bin/pgrep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";

  lock = pkgs.writeShellScriptBin "lock" ''
    wallpaper=$(${lib.getExe pkgs.swww} query | awk -F'image: ' 'NR==1 {print $2}')
    image=$(${pkgs.imagemagick}/bin/convert $wallpaper -blur 0x50 /tmp/lock.jpg && echo /tmp/lock.jpg)
    ${lib.getExe pkgs.gtklock} -b $image
  '';
  lockCommand = "${lock} -d";

  isLocked = "${pgrep} -x ${gtklock}";
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
        command = "${lockCommand}";
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
        command = "${lockCommand}";
      }
      # Lock
      {
        event = "lock";
        command = "${lockCommand}";
      }
      # Unlock
      {
        event = "unlock";
        command = "pkill -xu '$USER' -SIGUSR1 ${lockCommand}";
      }
    ];
  };
}
