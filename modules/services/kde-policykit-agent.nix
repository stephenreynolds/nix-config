{ config, lib, pkgs, ... }:

let cfg = config.modules.services.kde-policykit-agent;
in {
  options.modules.services.kde-policykit-agent = {
    enable = lib.mkEnableOption "KDE PolicyKit Agent";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kdePackages.polkit-kde-agent-1;
      defaultText = "pkgs.kdePackages.polkit-kde-agent-1";
      description = "KDE PolicyKit Agent package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    hm.systemd.user.services.kde-policykit-agent = {
      Unit = {
        Description = "KDE PolicyKit Agent";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
