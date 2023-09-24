{ inputs, ... }: {
  imports = [
    inputs.hyprland.homeManagerModules.default

    ../common
    ../common/tiling-wm/wayland

    ./tty-init.nix
    ./systemd-fixes.nix

    ./config
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    recommendedEnvironment = true;
  };

  home.sessionVariables = {
    "LIBVA_DRIVER_NAME" = "nvidia";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "WLR_NO_HARDWARE_CURSORS" = 1;
  };
}
