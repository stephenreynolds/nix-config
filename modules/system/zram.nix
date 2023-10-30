{ config, lib, ... }:
with lib;
let cfg = config.modules.system.zram;
in {
  options.modules.system.zram = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable zram";
    };
    memoryPercent = mkOption {
      type = types.int;
      default = 100;
      description = "Maximum total amount of memory that can be stored in zram";
    };
    optimizeSwapForZram = mkOption {
      type = types.bool;
      default = cfg.enable;
      description = "Whether to optimize swap for zram";
    };
  };

  config = mkIf cfg.enable {
    zramSwap = {
      enable = true;
      memoryPercent = cfg.memoryPercent;
    };

    # Source: https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
    boot.kernel.sysctl = mkIf cfg.optimizeSwapForZram {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
  };
}
