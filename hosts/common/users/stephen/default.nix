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
      "video"
      "audio"
      "gamemode"
    ] ++ ifTheyExist [
      "i2c"
      "docker"
      "podman"
      "git"
      "libvirtd"
      "mlocate"
      "flatpak"
    ];

    passwordFile = config.sops.secrets.stephen-password.path;
    packages = [ pkgs.home-manager ];
  };

  sops.secrets.stephen-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.stephen = import ../../../../home/stephen/${config.networking.hostName}.nix;

  services.geoclue2.enable = true;

  # Required to let swaylock check password.
  security.pam.services = { swaylock = { }; };
}
