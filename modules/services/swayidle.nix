{ config, lib, pkgs, ... }:

let
  cfg = config.modules.services.swayidle;

  pactl = "${pkgs.pulseaudio}/bin/pactl";
  hyprland = config.hm.wayland.windowManager.hyprland;
  hyprctl = "${hyprland.package}/bin/hyprctl";

  screenOffTime = 10 * 60; # 10 minutes
  lockTime = screenOffTime + 10; # 10 seconds
in {
  options.modules.services.swayidle = {
    enable = lib.mkEnableOption "Whether to enable swayidle";
    lockCommand = lib.mkOption {
      type = with lib.types; either package string;
      default = config.modules.desktop.tiling-wm.wayland.swaylock.lockCommand;
      description = "Command to run to lock the screen";
    };
  };

  config = lib.mkIf cfg.enable {
    hm.services.swayidle = {
      enable = true;
      timeouts =
        # Turn off displays
        (lib.optionals hyprland.enable [{
          timeout = screenOffTime;
          command = "${hyprctl} dispatch dpms off";
          resumeCommand = "${hyprctl} dispatch dpms on";
        }]) ++
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

    modules.services.sway-audio-idle-inhibit.enable = lib.mkDefault true;
  };
}
