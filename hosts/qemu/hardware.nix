{ lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd = {
      availableKernelModules =
        [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/9161fe08-56e1-430e-acb6-a434fd79d54e";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "boot" = {
      device = "/dev/disk/by-uuid/0C2D-B51C";
      fsType = "vfat";
    };
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
