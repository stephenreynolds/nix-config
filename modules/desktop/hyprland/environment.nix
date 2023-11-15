{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
  configPath = "${cfg.configPath}/00-environment.conf";

  nvidia = config.modules.system.nvidia.enable;

  sessionVariables =
    config.modules.desktop.tiling-wm.wayland.sessionVariables
    // lib.optionalAttrs nvidia {
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
  hm.home.file."${configPath}".text = lib.concatLines
    (lib.mapAttrsToList
      (key: value:
        "env = ${key}, ${toString value}")
      sessionVariables);
}
