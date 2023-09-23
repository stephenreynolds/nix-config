{
  programs.thunderbird = {
    enable = true;
    profiles.stephen = {
      isDefault = true;
    };
  };

  services.protonmail-bridge = {
    enable = true;
    nonInteractive = true;
  };
}
