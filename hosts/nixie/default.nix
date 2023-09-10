{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel-kaby-lake
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/stephen

    ../common/optional/systemd-boot.nix
    ../common/optional/network-manager.nix
    ../common/optional/zram.nix
    ../common/optional/system76-scheduler.nix
    ../common/optional/sddm.nix
    ../common/optional/hyprland.nix
    ../common/optional/gamemode.nix
    ../common/optional/game-memory-fix.nix
    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
    ../common/optional/nextdns.nix
    ../common/optional/tcp-bbr.nix
    ../common/optional/printing.nix
    ../common/optional/bluetooth.nix
    ../common/optional/xpadneo.nix
    ../common/optional/onedrive.nix
  ];

  networking = {
    hostName = "nixie";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "mitigations=off"
      "intel_iommu=on"
      "iommu=pt"
      "video=HDMI-A-1:1920x1080@70"
      "video=DP-1:1920x1080@70"
      "video=DP-2:1920x1080@70"
    ];
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
        nvidia-vaapi-driver
      ];
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
    openrgb.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  security.polkit.enable = true;

  services.gvfs.enable = true;

  system.stateVersion = "23.05";
}
