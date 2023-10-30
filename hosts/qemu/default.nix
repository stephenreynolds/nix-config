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
      bat.enable = true;
      btop.enable = true;
      comma = {
        enable = true;
        nix-index.enable = true;
      };
    };
  };
}
