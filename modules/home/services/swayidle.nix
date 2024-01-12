{ config, lib, pkgs, ... }:

let
  inherit (lib) optionals types mkOption mkEnableOption mkIf mkDefault;

  cfg = config.my.services.swayidle;

  pactl = "${pkgs.pulseaudio}/bin/pactl";
  hyprland = config.wayland.windowManager.hyprland;
  hyprctl = "${hyprland.package}/bin/hyprctl";

  screenOffTime = 10 * 60; # 10 minutes
  lockTime = screenOffTime + 10; # 10 seconds
in
{
  options.my.services.swayidle = {
    enable = mkEnableOption "Whether to enable swayidle";
    lockCommand = mkOption {
      type = with types; either package string;
      default = config.my.desktop.tiling-wm.wayland.swaylock.lockCommand;
      description = "Command to run to lock the screen";
    };
  };

  config = mkIf cfg.enable {
    services.swayidle = {
      enable = true;
      timeouts =
        # Turn off displays
        (optionals hyprland.enable ([{
          timeout = screenOffTime;
          command = "${hyprctl} dispatch dpms off";
          resumeCommand = "${hyprctl} dispatch dpms on";
        }])) ++
        # Lock screen
        [{
          timeout = lockTime;
          command = "${cfg.lockCommand}";
        }] ++
        # Mute mic
        [{
          timeout = lockTime;
          command = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
          resumeCommand = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";
        }];
      events = [
        # Before sleep
        {
          event = "before-sleep";
          command = "${cfg.lockCommand}";
        }
        # Lock
        {
          event = "lock";
          command = "${cfg.lockCommand}";
        }
        # Unlock
        {
          event = "unlock";
          command = "pkill -xu '$USER' ${cfg.lockCommand}";
        }
      ];
    };

    my.services.sway-audio-idle-inhibit.enable = mkDefault true;
  };
}
