{
  xdg.configFile."onedrive" = {
    enable = true;
    target = "onedrive/config";
    text = ''
      sync_dir = "~/.onedrive"
      enable_logging = "true"
    '';
  };

  home.persistence = {
    "/persist/home/stephen".directories = [
      ".config/onedrive"
    ];
  };
}
