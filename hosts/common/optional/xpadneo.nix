{
  hardware.xpadneo.enable = true;

  # Disable ERTM to fix connecting to Xbox One controllers
  boot.extraModprobeConfig = "options bluetooth disable_ertm=1";
}
