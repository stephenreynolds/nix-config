{ pkgs, config, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  users.users.stephen = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      # "video"
      # "audio"
    ] ++ ifTheyExist [
       # Add additional groups only if they exist
       # "i2c"
       # "docker"
       # "podman"
       # "git"
       # "libvirtd"
    ];

    # TODO: Try using SOPS
    passwordFile = "/etc/passwords/stephen";
    packages = [ pkgs.home-manager ];
  };

  home-manager.users.stephen = import ../../../../home/stephen/${config.networking.hostName}.nix;

  services.geoclue2.enable = true;

  # Required to let swaylock check password.
  security.pam.services = { swaylock = { }; };
}
