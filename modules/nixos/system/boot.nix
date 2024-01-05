{ config, lib, ... }:

let
  cfg = config.my.system.boot;
in
{
  options.my.system.boot = {
    bootloader = lib.mkOption {
      type = lib.types.enum [ "grub" "systemd-boot" ];
      default = "systemd-boot";
      description = "The booloader to use";
    };
    efi = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether the system is booted in EFI mode";
    };
    initrd = {
      systemd = {
        enable = lib.mkEnableOption "Whether to enable systemd in initrd";
      };
    };
    iommu = { enable = lib.mkEnableOption "Whether to enable IOMMU"; };
    extraKernelParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra kernel parameters";
    };
  };

  config = lib.mkMerge [
    {
      boot.loader.efi.canTouchEfiVariables = lib.mkDefault cfg.efi;
      boot.kernelParams = cfg.extraKernelParams;
    }

    (lib.mkIf (cfg.bootloader == "systemd-boot") {
      assertions = [{
        assertion = cfg.efi;
        message = "EFI mode is required to use systemd-boot";
      }];

      boot.loader.systemd-boot = {
        enable = true;
        consoleMode = "max";
        configurationLimit = 42;
        # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
        editor = false;
      };
    })

    (lib.mkIf (cfg.bootloader == "grub") {
      boot.loader.grub = {
        enable = true;
        efiSupport = lib.mkDefault cfg.efi;
        useOSProber = lib.mkDefault true;
      };
    })

    (lib.mkIf cfg.initrd.systemd.enable { boot.initrd.systemd.enable = true; })

    (lib.mkIf cfg.iommu.enable {
      boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
    })
  ];
}
