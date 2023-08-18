{
  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "stephen";
    };
  };
}
