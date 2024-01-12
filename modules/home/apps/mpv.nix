{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.apps.mpv;
in
{
  options.my.apps.mpv = {
    enable = mkEnableOption "Whether to install mpv";
  };

  config = mkIf cfg.enable {
    programs.mpv = {
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
