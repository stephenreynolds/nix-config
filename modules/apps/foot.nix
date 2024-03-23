{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.modules.apps.foot;
  foot-xterm = pkgs.writeShellScriptBin "xterm" ''
    ${config.hm.programs.foot.package}/bin/foot "$@"
    ${pkgs.pywal}/bin/wal -Rqnet
  '';
in
{
  options.modules.apps.foot = {
    enable = mkEnableOption "Whether to enable Foot";
    default = mkEnableOption ''
      Whether to make Foot the default terminal emulator
    '';
    server = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable Foot terminal server";
      };
    };
    font = {
      family = mkOption {
        type = types.string;
        default = config.modules.desktop.fonts.profiles.monospace.family;
      };
      size = mkOption {
        type = types.int;
        default = 10;
      };
    };
    padding = {
      horizontal = mkOption {
        type = types.int;
        default = 5;
      };
      vertical = mkOption {
        type = types.int;
        default = 5;
      };
    };
  };

  config = mkIf cfg.enable {
    hm.home = mkIf cfg.default {
      packages = [ foot-xterm ];
      sessionVariables = { TERMINAL = "foot"; };
    };

    hm.programs.foot = {
      enable = true;
      server.enable = cfg.server.enable;
      settings = {
        main = {
          font = "${cfg.font.family}:size=${builtins.toString cfg.font.size}";
          pad = "${builtins.toString cfg.padding.horizontal}x${builtins.toString cfg.padding.vertical} center";
          dpi-aware = true;
          bold-text-in-bright = true;
        };
        scrollback = {
          lines = 10000;
        };
        colors = {
          alpha = 0.9;
        };
      };
    };
  };
}
