{
  hardware.bluetooth = {
    enable = true;
  };

  services.blueman.enable = true;

  environment.persistence = {
    "/persist".directories = [
      "/var/lib/bluetooth"
    ];
  };
}
