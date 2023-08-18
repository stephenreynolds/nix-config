{
  systemd.user.services.openrgb = {
    Unit = {
      Description = "OpenRGB";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
      Type = "simple";
      ExecStart = "${config.services.openrgb.package}/bin/openrgb --profile 'All off'";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
