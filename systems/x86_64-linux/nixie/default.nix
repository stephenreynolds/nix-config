{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  my = {
    nix.auto-upgrade.enable = true;
    system = {
      bluetooth = {
        enable = true;
        blueman.enable = true;
        blueman.applet = true;
      };
      boot = {
        initrd.systemd.enable = true;
        iommu.enable = true;
      };
      cpu.intel = {
        enable = true;
        kaby-lake.enable = true;
      };
      locale.time.timeZone = "America/Detroit";
      networking = {
        networkManager = {
          enable = true;
          randomizeMac = true;
          wireguard-vpn.enable = true;
        };
      };
      nvidia.enable = true;
      pipewire.enable = true;
      plymouth.enable = true;
      security = {
        mitigations.disable = true;
        secure-boot.enable = false; # TODO: enable this
        tpm.enable = true;
      };
      ssd.enable = true;
      virtualisation = {
        host.enable = true;
        podman.enable = true;
      };
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
    desktop = {
      gnome = {
        enable = true;
	minimal = true;
      };
    };
    cli = {
      shell = {
        fish.enable = true;
      };
    };
  };

  system.stateVersion = "24.05";
}
