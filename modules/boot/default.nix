{ config, lib, ... }:
with lib;
let cfg = config.modules.boot;
in {
  options.modules.boot = {
    bootloader = mkOption {
      type = types.enum [ "grub" "systemd-boot" ];
      default = "grub";
      description = "The booloader to use";
    };
    efi = mkOption {
      type = types.bool;
      default = true;
      description = "Whether the system is booted in EFI mode";
    };
  };

  config = mkMerge [
    {
      assertions = [{
        assertion = cfg.bootloader == "systemd-boot" -> cfg.efi;
        message = "EFI mode is required to use systemd-boot";
      }];
    }

    { boot.loader.efi.canTouchEfiVariables = mkDefault cfg.efi; }

    (mkIf (cfg.bootloader == "grub") {
      boot.loader.grub = {
        enable = true;
        efiSupport = mkDefault cfg.efi;
        useOSProber = mkDefault true;
      };
    })

    (mkIf (cfg.bootloader == "systemd-boot") {
      boot.loader.systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
    })
  ];
}
