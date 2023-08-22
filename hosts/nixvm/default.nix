{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/stephen

    ../common/optional/systemd-boot.nix
    ../common/optional/zram.nix
    ../common/optional/system76-scheduler.nix
    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
    ../common/optional/nextdns.nix
    ../common/optional/printing.nix
  ];

  networking = {
    hostName = "nixvm";
    useDHCP = true;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  virtualisation.vmware.guest.enable = true;

  programs = {
    dconf.enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  security.polkit.enable = true;

  services.gvfs.enable = true;

  system.stateVersion = "23.05";
}
