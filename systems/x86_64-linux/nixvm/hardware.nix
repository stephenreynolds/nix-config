{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixvm";
    fsType = "ext4";
  };
}
