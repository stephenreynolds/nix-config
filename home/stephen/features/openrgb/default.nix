{
  xdg.configFile."All off.orp" = {
    source = ./off.orp;
    target = "OpenRGB/All off.orp";
  };

  systemd.user.services.openrgb-off = {
    Unit = {
      Description = "Turn off RGB";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "openrgb --profile 'All off'}";
      Restart = "on-failure";
    };
  };
}
