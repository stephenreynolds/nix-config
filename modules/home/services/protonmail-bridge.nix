# Source: https://github.com/nix-community/home-manager/issues/3019
{ config, lib, pkgs, ... }:

let
  inherit (lib) optionalString types mkOption mkEnableOption mkIf;
  cfg = config.my.services.protonmail-bridge;
in
{
  options.my.services.protonmail-bridge = {
    enable = mkEnableOption "Whether to enable protonmail-bridge";

    nonInteractive = mkOption {
      type = types.bool;
      default = true;
      description = "Start Bridge entirely noninteractively";
    };

    logLevel = mkOption {
      type = types.enum [
        "panic"
        "fatal"
        "error"
        "warn"
        "info"
        "debug"
        "debug-client"
        "debug-server"
      ];
      default = "info";
      description = "The log level";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.protonmail-bridge ];

    systemd.user.services.protonmail-bridge = {
      Unit = {
        Description = "Protonmail Bridge";
        After = [ "network.target" ];
      };

      Service = {
        Restart = "always";
        ExecStart =
          "${pkgs.protonmail-bridge}/bin/protonmail-bridge --log-level ${cfg.logLevel}"
          + optionalString (cfg.nonInteractive) " --noninteractive";
      };

      Install = { WantedBy = [ "default.target" ]; };
    };

    xdg.configFile."protonmail/bridge-v3/keychain.json".text = ''
      {
        "Helper": "secret-service-dbus"
      }
    '';
  };
}
