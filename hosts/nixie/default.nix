{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel-kaby-lake
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/stephen

    ../common/optional/systemd-boot.nix
    ../common/optional/zram.nix
    ../common/optional/gdm.nix
    ../common/optional/gamemode.nix
    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
    ../common/optional/nextdns.nix
    ../common/optional/printing.nix
    ../common/optional/bluetooth.nix
    ../common/optional/xpadneo.nix
    ../common/optional/onedrive.nix
  ];

  networking = {
    hostName = "nixie";
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
	      macAddress = "random";
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  programs = {
    dconf.enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
      ];
    };
    nvidia.modesetting.enable = true;
    openrgb.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  security.polkit.enable = true;

  services.gvfs.enable = true;

  system.stateVersion = "23.05";
}
