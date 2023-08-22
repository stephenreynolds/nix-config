{
  imports = [
    ./global
    ./features/desktop/hyprland
    ./features/productivity/latex.nix
  ];

  monitors = [
    {
      name = "DP-1";
      width = 1920;
      height = 1080;
      x = 0;
      workspace = "1";
    }
  ];
}
