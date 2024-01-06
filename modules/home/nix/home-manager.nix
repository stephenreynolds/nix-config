{ config, lib, ... }:

{
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault config.my.user.name;
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.05";

    language.base = "en_US.UTF-8";
  };

  systemd.user.startServices = "sd-switch";
}
