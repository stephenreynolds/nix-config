{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  my = {
    services = {
      onedrive.enable = true;
    };
    system = {
      bluetooth = {
        enable = true;
        blueman.enable = true;
      };
      boot = {
        initrd.systemd.enable = true;
        iommu.enable = true;
      };
      cpu.intel = {
        enable = true;
        gpu.blacklist = true;
      };
      locale.time.timeZone = "America/Detroit";
      networking = {
        networkManager = {
          enable = true;
          wireguard-vpn.enable = true;
        };
      };
      nvidia.enable = true;
      pipewire.enable = true;
      plymouth.enable = true;
      security = {
        mitigations.disable = true;
        secure-boot.enable = true;
        tpm.enable = true;
      };
      ssd.enable = true;
    };
    users = {
      users.stephen = {
        shell = pkgs.fish;
        extraGroups = [ "wheel" "input" "audio" "video" "storage" ];
        optionalGroups = [
          "i2c"
          "docker"
          "podman"
          "git"
          "libvirtd"
          "mlocate"
          "flatpak"
          "tss"
          "libvirtd"
          "gamemode"
          "nix-access-tokens"
          "openai-api-key"
        ];
      };
    };
    virtualisation = {
      host.enable = true;
      podman.enable = true;
    };
  };
}
