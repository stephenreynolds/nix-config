{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.system.boot;
in {
  options.modules.system.boot = {
    bootloader = mkOption {
      type = types.enum [ "grub" "systemd-boot" ];
      default = "systemd-boot";
      description = "The booloader to use";
    };
    efi = mkOption {
      type = types.bool;
      default = true;
      description = "Whether the system is booted in EFI mode";
    };
    initrd = {
      systemd = {
        enable = mkEnableOption "Whether to enable systemd in initrd";
      };
    };
    iommu = { enable = mkEnableOption "Whether to enable IOMMU"; };
    kernelPackages = mkOption {
      type = types.raw;
      default = pkgs.linuxPackages_latest;
      description = "The package of the Linux kernel";
    };
  };

  config = mkMerge [
    {
      boot.loader.efi.canTouchEfiVariables = mkDefault cfg.efi;
      boot.kernelPackages = cfg.kernelPackages;
    }

    (mkIf (cfg.bootloader == "systemd-boot") {
      assertions = [{
        assertion = cfg.efi;
        message = "EFI mode is required to use systemd-boot";
      }];

      boot.loader.systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
    })

    (mkIf (cfg.bootloader == "grub") {
      boot.loader.grub = {
        enable = true;
        efiSupport = mkDefault cfg.efi;
        useOSProber = mkDefault true;
      };
    })

    (mkIf cfg.initrd.systemd.enable { boot.initrd.systemd.enable = true; })

    (mkIf cfg.iommu.enable {
      boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
    })
  ];
}
