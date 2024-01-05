{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  my = {
    system = {
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
  };
}
