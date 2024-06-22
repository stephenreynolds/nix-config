{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkMerge mkIf mkDefault mkForce optionalString types;
  cfg = config.modules.system.boot;
in
{
  imports = [ inputs.chaotic.nixosModules.default ];

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
    watchdogs.enable = mkEnableOption "Whether to enable watchdog timers";
    kernel = {
      kernelPackages = mkOption {
        type = types.raw;
        default = pkgs.linuxPackages_latest;
        description = "The package of the Linux kernel";
      };
      extraKernelParams = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Extra kernel parameters";
      };
      cachyos-kernel = {
        enable = mkEnableOption "Whether to enable CachyOS's optimized kernel";
        scheduler = mkOption {
          type = types.enum [
            "scx_central"
            "scx_flatcg"
            "scx_lavd"
            "scx_layered"
            "scx_nest"
            "scx_pair"
            "scx_qmap"
            "scx_rlfifo"
            "scx_rustland"
            "scx_rusty"
            "scx_simple"
            "scx_userland"
          ];
          default = "scx_rusty";
          description = "Which SCX scheduler to use";
        };
      };
    };
  };

  config = mkMerge [
    {
      boot.loader.efi.canTouchEfiVariables = mkDefault cfg.efi;
      boot.kernelPackages = cfg.kernel.kernelPackages;
      boot.kernelParams = cfg.kernel.extraKernelParams;
    }

    (mkIf cfg.kernel.cachyos-kernel.enable {
      boot.kernelPackages = mkForce pkgs.linuxPackages_cachyos;
      chaotic.scx = {
        enable = true;
        scheduler = cfg.kernel.cachyos-kernel.scheduler;
      };
    })

    (mkIf (cfg.bootloader == "systemd-boot") {
      assertions = [{
        assertion = cfg.efi;
        message = "EFI mode is required to use systemd-boot";
      }];

      boot.loader.systemd-boot = {
        enable = true;
        consoleMode = "max";
        configurationLimit = 20;
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

    (mkIf (!cfg.watchdogs.enable) {
      boot.kernelParams = [ "nowatchdog" ];
      boot.extraModprobeConfig = optionalString config.modules.system.cpu.intel.enable ''
        blacklist iTCO_wdt
      '';
    })
  ];
}
