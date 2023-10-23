{ inputs, ... }: {
  imports = [
    inputs.hyprland.homeManagerModules.default

    ../common
    ../common/tiling-wm/wayland

    ./tty-init.nix
    ./systemd-fixes.nix
    ./xdg-autostart.nix

    ./config
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    recommendedEnvironment = true;
  };

  home.sessionVariables = {
    # Nvidia: https://wiki.hyprland.org/Nvidia
    "LIBVA_DRIVER_NAME" = "nvidia";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "WLR_NO_HARDWARE_CURSORS" = 1;
  };
}
