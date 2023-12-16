{ config, lib, pkgs, ... }:

let cfg = config.modules.services.sway-audio-idle-inhibit;
in {
  options.modules.services.sway-audio-idle-inhibit = {
    enable = lib.mkEnableOption "Whether to enable sway-audio-idle-inhibit";
  };

  config = lib.mkIf cfg.enable {
    hm.systemd.user.services.sway-audio-idle-inhibit = {
      Unit = {
        Description = "Inhibit audio idle suspend";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
        Restart = "on-failure";
      };
    };
  };
}
