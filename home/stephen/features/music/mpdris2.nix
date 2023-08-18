{ config, ... }:
{
  services.mpdris2 = {
    enable = true;
    mpd.musicDirectory = "${config.xdg.userDirs.music}";
    multimediaKeys = true;
    notifications = true;
  };
}
