{ lib, ... }:
let inherit (lib) mkDefault;
in {
  boot = {
    initrd.availableKernelModules =
      [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "ext4";
      options = [ "defaults" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      options = [ "noexec" "nosuid" "nodev" "umask=0077" ];
      fsType = "vfat";
    };
  };

  nixpkgs.hostPlatform = mkDefault "x86_64-linux";
}
