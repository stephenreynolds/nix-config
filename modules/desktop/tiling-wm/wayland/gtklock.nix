{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.desktop.tiling-wm.wayland.gtklock;

  baseConfig = ''
    [main]
    ${optionalString (cfg.config.gtk-theme != "") "gtk-theme=${cfg.config.gtk-theme}"}
    ${optionalString (cfg.config.style != "") "style=${cfg.config.style}"}
    ${optionalString (cfg.config.modules != []) "modules=${concatStringsSep ";" cfg.config.modules}"}
  '';

  finalConfig = baseConfig + optionals (cfg.extraConfig != null) (generators.toINI { } cfg.extraConfig);

  lockCommand = pkgs.writeShellScriptBin "lock" /* bash */ ''
    wallpaper=$(${getExe pkgs.swww} query | awk -F'image: ' 'NR==1 {print $2}')
    bg="$XDG_CACHE_HOME/gtklock/$(basename "$wallpaper").jpg"

    if [ ! -f "$bg" ]; then
      mkdir "$XDG_CACHE_HOME/gtklock"
      ${pkgs.imagemagick}/bin/convert "$wallpaper" -blur 0x50 "$bg"
    fi

    ${getExe pkgs.gtklock} -b $bg
  '';
in
{
  options.modules.desktop.tiling-wm.wayland.gtklock = {
    enable = mkEnableOption "Whether to enable gtklock";

    package = mkOption {
      type = types.package;
      default = pkgs.gtklock;
      defaultText = literalExample "pkgs.gtklock";
      description = "gtklock package to use";
    };

    config = {
      gtk-theme = mkOption {
        type = types.str;
        default = config.modules.desktop.theme.gtk.theme.name;
        description = "GTK theme to use";
        example = "Adwaita-dark";
      };

      style = mkOption {
        type = with types; oneOf [ str path ];
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
        example = literalExpression ''
          pkgs.writeText "gtklock-style.css" '''
              window {
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center;
              }
            '''
        '';
      };

      modules = mkOption {
        type = with types; listOf (either package str);
        default = [ "${pkgs.gtklock-powerbar-module.outPath}/lib/gtklock/powerbar-module.so" ];
        description = mdDoc ''
          A list of gtklock modules to use. Can either be packages, absolute paths, or strings."
        '';
        example = literalExpression ''
          [
            "${pkgs.gtklock-powerbar-module.outPath}/lib/gtklock/powerbar-module.so"
            "${pkgs.gtklock-playerctl-module.outPath}/lib/gtklock/playerctl-module.so"
          ];
        '';
      };
    };

    extraConfig = mkOption {
      type = with types; nullOr attrs;
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
      description = mdDoc ''
        Extra configuration to append to gtklock configuration file.
        Mostly used for appending module configurations.
      '';
      example = literalExpression ''
        countdown = {
          countdown-position = "top-right";
          justify = "right";
          countdown = 20;
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    hm.home.packages = [ cfg.package lockCommand ];

    hm.xdg.configFile."gtklock/config.ini".source = pkgs.writeText "gtklock-config.ini" finalConfig;

    security.pam.services.gtklock = { };
  };
}
