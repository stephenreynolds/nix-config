# BUG: gtklock is broken on Hyprland until it supports ext-session-lock-v1
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.tiling-wm.wayland.gtklock;

  baseConfig = ''
    [main]
    ${lib.optionalString (cfg.config.gtk-theme != "") "gtk-theme=${cfg.config.gtk-theme}"}
    ${lib.optionalString (cfg.config.style != "") "style=${cfg.config.style}"}
    ${lib.optionalString (cfg.config.modules != []) "modules=${lib.concatStringsSep ";" cfg.config.modules}"}
  '';

  finalConfig = baseConfig + lib.optionals (cfg.extraConfig != null) (lib.generators.toINI { } cfg.extraConfig);

  lockCommand = pkgs.writeShellScriptBin "lock" /* bash */ ''
    cacheDir="$XDG_CACHE_HOME/gtklock"
    wallpaper=$(${lib.getExe pkgs.swww} query | awk -F'image: ' 'NR==1 {print $2}')
    bg="$cacheDir/$(basename "$wallpaper").jpg"

    if [ ! -f "$bg" ]; then
      mkdir "$cacheDir"
      ${pkgs.imagemagick}/bin/convert "$wallpaper" -blur 0x50 "$bg"
    fi

    ${lib.getExe pkgs.gtklock} --daemonize -b $bg
  '';
in
{
  options.modules.desktop.tiling-wm.wayland.gtklock = {
    enable = lib.mkEnableOption "Whether to enable gtklock";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gtklock;
      defaultText = "pkgs.gtklock";
      description = "gtklock package to use";
    };

    lockCommand = lib.mkOption {
      type = lib.types.package;
      default = lockCommand;
      description = "Command to run gtklock with";
    };

    config = {
      gtk-theme = lib.mkOption {
        type = lib.types.str;
        default = config.modules.desktop.theme.gtk.theme.name;
        description = "GTK theme to use";
        example = "Adwaita-dark";
      };

      style = lib.mkOption {
        type = with lib.types; oneOf [ str path ];
        default = pkgs.writeText "gtklock-style.css" /* scss */ ''
          window {
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
          }

          #clock-label {
            margin-bottom: 30px;
            font-size: 800%;
            font-weight: bold;
            color: white;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
          }

          #body {
            margin-top: 50px;
          }

          #unlock-button {
            all: unset;
            color: transparent;
          }

          entry {
            border-radius: 12px;
            margin: 1px;
            box-shadow: 1px 2px 4px rgba(0, 0, 0, 0.1);
          }

          #input-label {
            color: transparent;
            margin: -20rem;
          }

          #powerbar-box * {
            border-radius: 12px;
            box-shadow: 1px 2px 4px rgba(0, 0, 0, 0.1);
          }
        '';
        description = "The css file to be used for gtklock";
        example = ''
          pkgs.writeText "gtklock-style.css" '''
              window {
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center;
              }
            '''
        '';
      };

      modules = lib.mkOption {
        type = with lib.types; listOf (either package str);
        default = [ "${pkgs.gtklock-powerbar-module.outPath}/lib/gtklock/powerbar-module.so" ];
        description = ''
          A list of gtklock modules to use. Can either be packages, absolute paths, or strings."
        '';
        example = ''
          [
            "${pkgs.gtklock-powerbar-module.outPath}/lib/gtklock/powerbar-module.so"
            "${pkgs.gtklock-playerctl-module.outPath}/lib/gtklock/playerctl-module.so"
          ];
        '';
      };
    };

    extraConfig = lib.mkOption {
      type = with lib.types; nullOr attrs;
      default = {
        main = {
          time-format = "%-I:%M %p";
          start-hidden = true;
          idle-hide = true;
          idle-timeout = 30;
        };
        countdown = {
          countdown-position = "top-right";
          justify = "right";
          countdown = 20;
        };
      };
      description = ''
        Extra configuration to append to gtklock configuration file.
        Mostly used for appending module configurations.
      '';
      example = ''
        countdown = {
          countdown-position = "top-right";
          justify = "right";
          countdown = 20;
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hm.home.packages = [ cfg.package cfg.lockCommand ];

    hm.xdg.configFile."gtklock/config.ini".source = pkgs.writeText "gtklock-config.ini" finalConfig;

    security.pam.services.gtklock = { };
  };
}
