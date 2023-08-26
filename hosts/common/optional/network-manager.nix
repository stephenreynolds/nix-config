{
  networking.networkmanager = {
    enable = true;
    wifi = {
      backend = "iwd";
      macAddress = "random";
    };
  };

  environment.persistence = {
    "/persist".directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/iwd"
    ];
  };
}
