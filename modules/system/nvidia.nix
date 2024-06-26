{ config, lib, pkgs, ... }:

let cfg = config.modules.system.nvidia;
in {
  options.modules.system.nvidia = {
    enable = lib.mkEnableOption "Whether to install Nvidia drivers";
    package = lib.mkOption {
      type = lib.types.package;
      default = config.boot.kernelPackages.nvidiaPackages.stable;
      description = "The Nvidia driver package to install";
    };
    open = lib.mkEnableOption "Whether to install the open kernel modules";
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [ vaapiVdpau nvidia-vaapi-driver ];
      description = "Extra packages to install with the Nvidia drivers";
    };
    nvidiaSettings = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable nvidia-settings";
    };
    support32Bit = lib.mkEnableOption "Whether to enable 32-bit support";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      graphics = {
        enable32Bit = cfg.support32Bit;
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

    boot.extraModprobeConfig = ''
      options nvidia NVreg_TemporaryFilePath=/var/tmp NVreg_UsePageAttributeTable=1
      options nvidia_drm fbdev=1
    '';

    hm.home.sessionVariables.CUDA_CACHE_PATH = "${config.hm.xdg.cacheHome}/nv";
  };
}
