{
  imports = [ ./hardware.nix ];

  modules = {
    networking = { networkManager.enable = true; };
    boot = { bootloader = "systemd-boot"; };
    locale = { time.timeZone = "America/Detroit"; };
    users = {
      users.stephen.enable = true;
    };
    shell = {
      fish.enable = true;
    };
  };
}
