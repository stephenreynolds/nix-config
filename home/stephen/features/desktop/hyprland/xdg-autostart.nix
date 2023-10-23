{
  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland compositor session";
      BindsTo = [ "graphical-session.target" ];
      Wants = [
        "graphical-session-pre.target"
        "xdg-desktop-autostart.target"
      ];
      After = [
        "graphical-session-pre.target"
      ];
      Before = [
        "xdg-desktop-autostart.target"
      ];
    };
  };
}
