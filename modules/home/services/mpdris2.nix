{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.services.mpdris2;
in
{
  options.my.services.mpdris2 = {
    enable = mkEnableOption "Whether to enable mpdris2";
  };

  config = mkIf cfg.enable {
    hm.services.mpdris2 = {
      enable = true;
      mpd.musicDirectory = "${config.hm.xdg.userDirs.music}";
      multimediaKeys = true;
      notifications = true;
    };
  };
}
