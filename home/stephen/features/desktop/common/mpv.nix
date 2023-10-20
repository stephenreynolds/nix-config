{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    package = pkgs.wrapMpv pkgs.mpv-unwrapped {
      youtubeSupport = true;
    };
    config = {
      profile = "gpu-hq";
      vo = "gpu";
      hwdec = "auto-safe";
    };
  };
}
