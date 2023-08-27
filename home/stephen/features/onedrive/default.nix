{
  xdg.configFile."onedrive" = {
    enable = true;
    target = "onedrive/config";
    text = ''
      sync_dir = "~/.onedrive"
    '';
  };

  home.persistence = {
    "/persist/home/stephen".directories = [
      ".config/onedrive"
    ];
  };
}
