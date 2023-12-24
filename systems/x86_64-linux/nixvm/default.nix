{ ... }:

{
  imports = [ ./hardware.nix ];

  my = {
    system = {
      boot.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
