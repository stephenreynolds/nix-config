{
  services.onedrive.enable = true;

  environment.persistence."/persist".directories = [
    { directory = "/var/log/onedrive"; user = "root"; group = "users"; mode = "0775"; }
  ];
}
