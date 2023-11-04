{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.system.nvidia;
in {
  options.modules.system.nvidia = {
    enable = mkEnableOption "Whether to install Nvidia drivers";
    package = mkOption {
      type = types.package;
      default = config.boot.kernelPackages.nvidiaPackages.stable;
      description = "The Nvidia driver package to install";
    };
    open = mkEnabletoption "Whether to install the open kernel modules";
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [ vaapiVdpau nvidia-vaapi-driver ];
      description = "Extra packages to install with the Nvidia drivers";
    };
    nvidiaSettings = mkEnableOption "Whether to enable nvidia-settings";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = cfg.extraPackages;
      };
      nvidia = {
        package = cfg.package;
        open = cfg.open;
        modesetting.enable = true;
        powerManagement.enable = true;
        nvidiaSettings = cfg.nvidiaSettings;
      };
    };

    boot.kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      "nvidia-drm.fbdev=1"
    ];
  };
}