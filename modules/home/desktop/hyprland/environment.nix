{ config, lib, ... }:

let
  cfg = config.my.desktop.hyprland;

  sessionVariables =
    config.my.desktop.tiling-wm.wayland.sessionVariables
    // lib.optionalAttrs cfg.nvidia {
      # Nvidia: https://wiki.hyprland.org/Nvidia
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = 1;
      NVD_BACKEND = "direct";
      MOZ_DISABLE_RDD_SANDBOX = 1;
    };
in
lib.mkIf cfg.enable {
  wayland.windowManager.hyprland.settings.env =
    lib.mapAttrsToList
      (key: value:
        "${key}, ${toString value}")
      sessionVariables;
}
