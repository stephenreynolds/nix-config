{ config, lib, pkgs, ... }:

let cfg = config.my.system.cpu.intel;
in {
  imports = [ ./kaby-lake.nix ];

  options.my.system.cpu.intel = {
    enable = lib.mkEnableOption "Whether to enable options for Intel CPUs";
  };

  config = lib.mkIf cfg.enable {
    hardware.cpu.intel.updateMicrocode = true;

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
  };
}
