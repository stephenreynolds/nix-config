{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.my.desktop.hyprland;
in
{
  options.my.desktop.hyprland = {
    enable = lib.mkEnableOption "Whether to enable Hyprland";
    xdg-autostart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to autostart programs that ask for it";
    };
    configPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.hm.xdg.configHome}/hypr/conf.d";
      description = "Path to Hyprland configuration files";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      my.desktop.tiling-wm = {
        enable = true;
        wayland = {
          enable = true;
          ags.enable = true;
          swww.enable = true;
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      };

      # Stolen from https://github.com/alebastr/sway-systemd/commit/0fdb2c4b10beb6079acd6073c5b3014bd58d3b74
      systemd.user.targets.hyprland-session-shutdown = {
        Unit = {
          Description = "Shutdown running Hyprland session";
          DefaultDependencies = "no";
          StopWhenUnneeded = "true";

          Conflicts = [
            "graphical-session.target"
            "graphical-session-pre.target"
            "hyprland-session.target"
          ];
          After = [
            "graphical-session.target"
            "graphical-session-pre.target"
            "hyprland-session.target"
          ];
        };
      };
    }

    (lib.mkIf cfg.xdg-autostart {
      systemd.user.targets.hyprland-session = {
        Unit = {
          Description = "Hyprland compositor session";
          BindsTo = [ "graphical-session.target" ];
          Wants = [ "graphical-session-pre.target" "xdg-desktop-autostart.target" ];
          After = [ "graphical-session-pre.target" ];
          Before = [ "xdg-desktop-autostart.target" ];
        };
      };
    })
  ]);
}
