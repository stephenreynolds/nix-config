{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.amberol;
in {
  options.modules.apps.amberol = {
    enable = lib.mkEnableOption "Whether to install amberol";
  };

  config = lib.mkIf cfg.enable {
    hm.home.packages = [ pkgs.amberol ];

    hm.xdg.mimeApps.defaultApplications = {
      "audio/*" = "io.bassi.Amberol";
      "audio/flac" = "io.bassi.Amberol";
      "audio/vnd.wave" = "io.bassi.Amberol";
    };
  };
}
