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
        kaby-lake.enable = true;
      };
      locale.time.timeZone = "America/Detroit";
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
