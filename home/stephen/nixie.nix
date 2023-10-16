{
  imports = [
    ./global
    ./features/desktop/hyprland
    ./features/games
    ./features/productivity
    ./features/music
    ./features/audio/corsair-virtuoso-wireless-headset
    ./features/openrgb
    ./features/onedrive
    ./features/security
    ./features/stable-diffusion
  ];

  #  ------   ------   ----------
  # | DP-1 | | DP-2 | | HDMI-A-1 |
  #  ------   ------   ----------
  monitors = [
    {
      name = "DP-1";
      width = 1920;
      height = 1080;
      refreshRate = 70;
      x = 0;
    }
    {
      name = "DP-2";
      width = 1920;
      height = 1080;
      refreshRate = 70;
      x = 1920;
      primary = true;
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      refreshRate = 70;
      x = 3840;
    }
  ];
}
