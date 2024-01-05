{ config, lib, pkgs, ... }:

let cfg = config.my.system.nvidia;
in {
  options.my.system.nvidia = {
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
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = cfg.support32Bit;
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
    '';

    boot.kernelParams = [
      "nvidia-drm.fbdev=1"
    ];
  };
}
