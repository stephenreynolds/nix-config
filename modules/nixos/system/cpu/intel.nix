{ config, lib, pkgs, ... }:

let cfg = config.my.system.cpu.intel;
in {
  options.my.system.cpu.intel = {
    enable = lib.mkEnableOption "Whether to enable options for Intel CPUs";
    gpu = {
      enable = lib.mkEnableOption "Whether to enable Intel integrated graphics";
      blacklist = lib.mkEnableOption "Whether to blacklist Intel graphics drivers";
      kaby-lake = lib.mkEnableOption "Whether to enable options for Intel Kaby Lake CPUs";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [{
        assertion = cfg.gpu.enable -> !cfg.gpu.blacklist;
        message = "Intel graphics drivers are enabled but blacklisted";
      }];
    }

    {
      hardware.cpu.intel.updateMicrocode = true;
    }

    (lib.mkIf cfg.gpu.enable {
      # Below obtained from github:nixos-hardware/common/cpu/intel
      boot.initrd.kernelModules = [ "i915" ];

      environment.variables = {
        VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
      };

      hardware.opengl.extraPackages = with pkgs; [
        intel-vaapi-driver
        libvdpau-va-gl
        intel-media-driver
      ];

      boot.kernelParams = lib.mkIf cfg.gpu.kaby-lake [
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
      ];
    })

    (lib.mkIf cfg.gpu.blacklist {
      boot.blacklistedKernelModules = lib.mkDefault [ "i915" ];
      # KMS will load the module, regardless of blacklisting
      boot.kernelParams = lib.mkDefault [ "i915.modeset=0" ];
    })
  ]);
}
