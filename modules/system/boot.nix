{ config, lib, ... }:
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
  };

  config = mkMerge [
    { boot.loader.efi.canTouchEfiVariables = mkDefault cfg.efi; }

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
  ];
}
