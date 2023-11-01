{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.gtklock;

  baseConfig = ''
    [main]
    ${optionalString (cfg.config.gtk-theme != "") "gtk-theme=${cfg.config.gtk-theme}"}
    ${optionalString (cfg.config.style != "") "style=${cfg.config.style}"}
    ${optionalString (cfg.config.modules != []) "modules=${concatStringsSep ";" cfg.config.modules}"}
  '';

  finalConfig = baseConfig + optionals (cfg.extraConfig != null) (generators.toINI { } cfg.extraConfig);
in
{
  options.programs.gtklock = {
    enable = mkEnableOption "gtklock";

    package = mkOption {
      type = types.package;
      default = pkgs.gtklock;
      defaultText = literalExample "pkgs.gtklock";
      description = "gtklock package to use";
    };

    config = {
      gtk-theme = mkOption {
        type = types.str;
        default = "";
        description = "GTK theme to use";
        example = "Adwaita-dark";
      };

      style = mkOption {
        type = with types; oneOf [ str path ];
        default = "";
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
        default = [ ];
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
    home.packages = [ cfg.package ];

    xdg.configFile."gtklock/config.ini".source = pkgs.writeText "gtklock-config.ini" finalConfig;
  };
}