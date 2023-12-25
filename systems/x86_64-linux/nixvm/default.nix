{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  my = {
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
      pipewire.enable = true;
      plymouth.enable = true;
      ssd.enable = true;
      virtualisation = {
        host = {
          enable = true;
          users = [ "stephen" ];
        };
      };
    };
    users = {
      users.stephen = {
        shell = pkgs.fish;
        extraGroups = [ "wheel" ];
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
