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
    { boot.loader.efi.canTouchEfiVariables = mkDefault cfg.boot.efi; }

    (mkIf (cfg.bootloader == "grub") {
      boot.loader.grub = {
        enable = true;
        efiSupport = mkDefault cfg.boot.efi;
        useOSProber = mkDefault true;
      };
    })

    (mkIf (cfg.bootloader == "systemd-boot") {
      boot.loader.systemd-boot.enable = true;
    })
  ];
}
