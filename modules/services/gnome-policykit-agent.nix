{ config, lib, pkgs, ... }:

let cfg = config.modules.services.gnome-policykit-agent;
in {
  options.modules.services.gnome-policykit-agent = {
    enable = lib.mkEnableOption "GNOME PolicyKit Agent";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.polkit_gnome;
      defaultText = "pkgs.polkit-gnome";
      description = "GNOME PolicyKit Agent package to use";
    };
  };

  config = lib.mkIf cfg.enable {
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
