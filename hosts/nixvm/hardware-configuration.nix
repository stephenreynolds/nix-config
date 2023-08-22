{
  boot = {
    initrd = {
      availableKernelModules = [ "ata_piix" "uhci_hcd" "ehci_pci" "nvme" "sr_mod" ];
    };
  };

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress-force=zstd" "space_cache=v2" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
      options = [ "subvol=persist" "noatime" "compress-force=zstd" "space_cache=v2" ];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

  nixpkgs.hostPlatform = "x86_64-linux";
}
