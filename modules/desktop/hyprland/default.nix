{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.modules.desktop.hyprland;
in
{
  options.modules.desktop.hyprland = {
    enable = lib.mkEnableOption "Whether to enable Hyprland";
    xdg-autostart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to autostart programs that ask for it";
    };
    tty = lib.mkEnableOption "Whether to start Hyprland on login from tty1";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      modules.desktop.tiling-wm = {
        enable = true;
        wayland = {
          enable = true;
          ags.enable = true;
          swww.enable = true;
        };
      };

      hm.imports = [ inputs.hyprland.homeManagerModules.default ];

      hm.wayland.windowManager.hyprland = {
        enable = true;
        pacakge = pkgs.hyprland;
        reloadConfig = true;
        systemdIntegration = true;
        recommendedEnvironment = true;
        xwayland.enable = true;
      };

      xdg.portal = {
        enable = true;
        extraPortals = [
          inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
          pkgs.xdg-desktop-portal-gtk
        ];
        config = {
          common = {
            default = [ "gtk" ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };
          hyprland = {
            default = [ "gtk" "hyprland" ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };
        };
      };

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

    (lib.mkIf cfg.tty {
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

    (lib.mkIf cfg.xdg-autostart {
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
