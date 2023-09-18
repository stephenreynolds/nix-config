{
  services.onedrive.enable = true;

  systemd.tmpfiles.rules = [
    "d /var/log/onedrive 0775 root users"
  ];
}
