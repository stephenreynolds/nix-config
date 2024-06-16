{ config, lib, ... }:

let cfg = config.modules.apps.mpv;
in {
  options.modules.apps.mpv = {
    enable = lib.mkEnableOption "Whether to install mpv";
  };

  config = lib.mkIf cfg.enable {
    hm.programs.mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        vo = "gpu";
        hwdec = "auto-safe";
      };
    };
  };
}
