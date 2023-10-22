{
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
        softrealtime = "on";
        inhibit_screensaver = 1;
      };
    };
  };
}
