{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.services.gnome-policykit-agent;
in {
  options.modules.services.gnome-policykit-agent = {
    enable = mkEnableOption "GNOME PolicyKit Agent";
    package = mkOption {
      type = types.package;
      default = pkgs.polkit_gnome;
      defaultText = literalExample "pkgs.polkit-gnome";
      description = "GNOME PolicyKit Agent package to use";
    };
  };

  config = mkIf cfg.enable {
    hm.systemd.user.services.gnome-policykit-agent = {
      Unit = {
        Description = "GNOME PolicyKit Agent";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        Type = "simple";
        ExecStart =
          "${cfg.package}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}