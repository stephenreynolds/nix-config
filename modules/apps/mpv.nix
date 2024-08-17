{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types;
  cfg = config.modules.apps.mpv;
in
{
  options.modules.apps.mpv = {
    enable = mkEnableOption "Whether to install mpv";
    youtube = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable YouTube support";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.programs.mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [
          mpris
          mpv-playlistmanager
          quality-menu
        ];
        config = {
          profile = "gpu-hq";
          vo = "gpu";
          hwdec = "auto-safe";
        };
      };
    }

    (mkIf cfg.youtube {
      hm.home.packages = [ pkgs.yt-dlp ];
    })
  ]);
}
