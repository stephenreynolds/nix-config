{ config, pkgs, ... }:
let
  wallpaper-path = "${config.xdg.configHome}/wallpaper";
in
{
  systemd.user.services.swww = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      ExecStartPost = "${pkgs.swww}/bin/swww img '${wallpaper-path}'";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
