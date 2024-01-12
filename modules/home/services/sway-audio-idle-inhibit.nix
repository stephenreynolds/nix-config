{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.services.sway-audio-idle-inhibit;
in
{
  options.my.services.sway-audio-idle-inhibit = {
    enable = mkEnableOption "Whether to enable sway-audio-idle-inhibit";
  };

  config = mkIf cfg.enable {
    systemd.user.services.sway-audio-idle-inhibit = {
      Unit = {
        Description = "Inhibit audio idle suspend";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
