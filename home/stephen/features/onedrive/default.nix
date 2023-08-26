{
  xdg.configFile."onedrive" = {
    enable = true;
    target = "onedrive/config";
    text = ''
      sync_dir = "~/.onedrive"
    '';
  };
}
