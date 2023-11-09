{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.apps.mpv;
in {
  options.modules.apps.mpv = {
    enable = mkEnableOption "Whether to install mpv";
  };

  config = mkIf cfg.enable {
    hm.programs.mpv = {
      enable = true;
      package = pkgs.wrapMpv pkgs.mpv-unwrapped { youtubeSupport = true; };
      config = {
        profile = "gpu-hq";
        vo = "gpu";
        hwdec = "auto-safe";
      };
    };
  };
}
