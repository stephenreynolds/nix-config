{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.system.cpu.intel;
in {
  options.modules.system.cpu.intel = {
    enable = mkEnableOption "Whether to enable options for Intel CPUs";
  };

  config = mkIf cfg.enable {
    hardware.cpu.intel.updateMicrocode = true;

    # Below obtained from github:nixos-hardware/common/cpu/intel
    boot.initrd.kernelModules = [ "i915" ];

    environment.variables = {
      VDPAU_DRIVER = mkIf config.hardware.opengl.enable (mkDefault "va_gl");
    };

    hardware.opengl.extraPackages = with pkgs; [
      intel-vaapi-driver
      libvdpau-va-gl
      intel-media-driver
    ];
  };
}
