{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.modules.desktop.hyprland;
  nvidia = config.modules.system.nvidia.enable;
  configPath = cfg.configPath;
in
{
  imports = [ inputs.hyprland.nixosModules.default ];

  options.modules.desktop.hyprland = {
    enable = mkEnableOption "Whether to enable Hyprland";
    xdg-autostart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to autostart programs that ask for it";
    };
    tty = mkEnableOption "Whether to start Hyprland on login from tty1";
    configPath = mkOption {
      type = types.str;
      default = "${config.hm.xdg.configHome}/hypr/conf.d";
      description = "Path to Hyprland configuration files";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      modules.desktop.tiling-wm = {
        enable = true;
        wayland = {
          enable = true;
          ags.enable = true;
          swww.enable = true;
        };
      };

      programs.hyprland.enable = true;

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      hm.imports = [ inputs.hyprland.homeManagerModules.default ];

      hm.wayland.windowManager.hyprland.enable = true;

      hm.wayland.windowManager.hyprland.extraConfig = ''
        source = ${configPath}/*.conf
      '';

      # Stolen from https://github.com/alebastr/sway-systemd/commit/0fdb2c4b10beb6079acd6073c5b3014bd58d3b74
      hm.systemd.user.targets.hyprland-session-shutdown = {
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

    (mkIf nvidia {
      programs.hyprland.enableNvidiaPatches = true;
      hm.wayland.windowManager.hyprland.enableNvidiaPatches = true;
    })

    (mkIf cfg.tty {
      hm.programs = {
        fish.loginShellInit = /* fish */ ''
          if test (tty) = "/dev/tty1"
            exec Hyprland &> /dev/null
          end
        '';
        zsh.loginExtra = /* bash */ ''
          if [ "$(tty)" = "/dev/tty1" ]; then
            exec Hyprland &> /dev/null
          fi
        '';
        zsh.profileExtra = /* bash */ ''
          if [ "$(tty)" = "/dev/tty1" ]; then
            exec Hyprland &> /dev/null
          fi
        '';
      };
    })

    (mkIf cfg.xdg-autostart {
      hm.systemd.user.targets.hyprland-session = {
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
