{
  services.mpdris2 = {
    enable = true;
    mpd.musicDirectory = "${xdg.userDirs.music}";
    multimediaKeys = true;
    notifications = true;
  };
}
