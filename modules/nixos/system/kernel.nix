{ config, lib, pkgs, ... }:

let cfg = config.my.system.kernel;
in {
  options.my.system.kernel = {
    kernelPackages = lib.mkOption {
      type = lib.types.raw;
      default = pkgs.linuxPackages_latest;
      description = "The package of the Linux kernel";
    };
  };

  config = {
    boot.kernelPackages = cfg.kernelPackages;
  };
}
