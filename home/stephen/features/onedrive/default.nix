{ config, ... }:
{
  xdg.configFile."onedrive" = {
    enable = true;
    target = "onedrive/config";
    text = ''
      sync_dir = "~/.onedrive"
      enable_logging = "true"
    '';
  };

  home.file = {
    "Documents".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.onedrive/Documents";
    "Music".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.onedrive/Music";
    "Pictures".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.onedrive/Pictures";
    "Videos".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.onedrive/Videos";
  };

  xdg.userDirs.documents = "${config.home.homeDirectory}/.onedrive/Documents";
  xdg.userDirs.music = "${config.home.homeDirectory}/.onedrive/Music";
  xdg.userDirs.pictures = "${config.home.homeDirectory}/.onedrive/Pictures";
  xdg.userDirs.videos = "${config.home.homeDirectory}/.onedrive/Videos";

  home.persistence = {
    "/persist/home/stephen" = {
      directories = [
        ".config/onedrive"
        ".onedrive"
      ];
      allowOther = true;
    };
  };
}
