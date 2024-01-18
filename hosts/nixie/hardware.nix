{ config, lib, ... }:
let hostname = config.networking.hostName;
in {
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/nix" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress-force=zstd" "space_cache=v2" "x-gvfs-hide" ];
    };
    "/persist" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=persist" "noatime" "compress-force=zstd" "space_cache=v2" "x-gvfs-hide" ];
      neededForBoot = true;
    };
    "/cache" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=cache" "noatime" "compress-force=zstd" "space_cache=v2" "x-gvfs-hide" ];
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      options = [ "noexec" "nosuid" "nodev" "umask=0077" ];
      fsType = "vfat";
    };
  };

  nixpkgs.hostPlatform = lib.lib.mkDefault "x86_64-linux";
}
