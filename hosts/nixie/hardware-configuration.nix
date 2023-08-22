{
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = { device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
      options = [ "subvol=@" "noatime" "compress-force=zstd" "space_cache=v2" ];
    };

    "/home" = { device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
      options = [ "subvol=@home" "noatime" "compress-force=zstd" "space_cache=v2" ];
    };

    "/nix" = { device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
      options = [ "subvol=@nix" "noatime" "compress-force=zstd" "space_cache=v2" ];
    };

    "/boot" = { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
