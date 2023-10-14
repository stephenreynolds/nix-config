{ pkgs, lib, config, ... }:
let
  cfg = config.programs.swww;
in
{
  options.programs.swww = {
    enable = lib.options.mkEnableOption "swww";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.swww = {
      Unit = {
        Description = "Wayland wallpaper daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        ExecStop = "${lib.getExe pkgs.swww} kill";
        Restart = "on-failure";
      };
    };
  };
}
