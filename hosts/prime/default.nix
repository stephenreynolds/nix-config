{ pkgs, ... }: {
  imports = [ ./hardware.nix ];

  config = {
    modules = {
      cli.shell.zsh.enable = true;
      desktop = { i3.enable = true; };
      users.users = {
        generic = {
          enable = true;
          name = "prime";
          initialPassword = "prime";
          shell = pkgs.zsh;
        };
      };
      system = {
        networking.networkManager.enable = true;
        virtualisation.guest = {
          qemu = true;
          qxl = true;
          spice = true;
        };
      };
    };

    hardware.graphics.enable = true;
  };
}
