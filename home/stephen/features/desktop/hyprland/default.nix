{ lib, inputs, outputs, ... }:
let
  nvidia = builtins.elem "nvidia"
    outputs.nixosConfigurations.nixie.config.services.xserver.videoDrivers;
in {
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
    enableNvidiaPatches = nvidia;
    recommendedEnvironment = true;
  };

  home.sessionVariables = lib.mkIf nvidia {
    # Nvidia: https://wiki.hyprland.org/Nvidia
    "LIBVA_DRIVER_NAME" = "nvidia";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "WLR_NO_HARDWARE_CURSORS" = 1;
  };
}
