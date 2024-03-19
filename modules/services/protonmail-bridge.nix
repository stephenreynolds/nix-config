# Source: https://github.com/nix-community/home-manager/issues/3019
{ config, lib, pkgs, ... }:

let cfg = config.modules.services.protonmail-bridge;
in {
  options.modules.services.protonmail-bridge = {
    enable = lib.mkEnableOption "Whether to enable protonmail-bridge";

    nonInteractive = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Start Bridge entirely noninteractively";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
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

  config = lib.mkIf cfg.enable {
    hm.home.packages = [ pkgs.protonmail-bridge ];

    hm.systemd.user.services.protonmail-bridge = {
      Unit = {
        Description = "Protonmail Bridge";
        After = [ "network.target" ];
      };

      Service = {
        Restart = "always";
        ExecStart =
          "${pkgs.protonmail-bridge}/bin/protonmail-bridge --log-level ${cfg.logLevel}"
          + lib.optionalString cfg.nonInteractive " --noninteractive";
      };

      Install = { WantedBy = [ "default.target" ]; };
    };

    hm.xdg.configFile."protonmail/bridge-v3/keychain.json".text = ''
      {
        "Helper": "secret-service-dbus"
      }
    '';
  };
}
