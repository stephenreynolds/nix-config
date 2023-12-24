{ config, lib, ... }:

let cfg = config.my.system.cpu.intel.kaby-lake;
in {
  options.my.system.cpu.intel.kaby-lake = {
    enable = lib.mkEnableOption "Whether to enable options for Intel Kaby Lake CPUs";
  };

  config = lib.mkIf cfg.enable {
    # Obtained from github:nixos-hardware/common/cpu/intel
    boot.kernelParams = [ "i915.enable_fbc=1" "i915.enable_psr=2" ];
  };
}
