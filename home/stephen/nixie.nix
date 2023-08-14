{ inputs, outputs, ...}: {
  imports = [
    ./global
    ./features/desktop/hyprland
    ./features/games
    ./features/latex
  ];

  #  ------   ------   ----------
  # | DP-1 | | DP-2 | | HDMI-A-1 |
  #  ------   ------   ----------
  monitors = [
    {
      name = "DP-1";
      width = 1920;
      height = 1080;
      x = 0;
      workspace = "1";
    }
    {
      name = "DP-2";
      width = 1920;
      height = 1080;
      x = 1920;
      workspace = "2";
      primary = true;
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      x = 3840;
      workspace = "3";
    }
  ];
}
