{
  imports = [
    ./global
    ./features/audio/corsair-virtuoso-wireless-headset
    ./features/desktop/hyprland
    ./features/games
    ./features/music
    ./features/onedrive
    ./features/openrgb
    ./features/productivity
    ./features/stable-diffusion
    ./features/wine
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
      modeline = "modeline 205.20 1920 2056 2264 2608 1080 1081 1084 1124 -hsync +vsync";
      x = 0;
    }
    {
      name = "DP-2";
      width = 1920;
      height = 1080;
      refreshRate = 70;
      modeline = "modeline 205.20 1920 2056 2264 2608 1080 1081 1084 1124 -hsync +vsync";
      x = 1920;
      primary = true;
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      refreshRate = 70;
      modeline = "modeline 205.20 1920 2056 2264 2608 1080 1081 1084 1124 -hsync +vsync";
      x = 3840;
    }
  ];
}
