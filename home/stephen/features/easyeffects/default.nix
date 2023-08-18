{
  services.easyeffects = {
    enable = true;
    preset = "Equalizer";
  };

  xdg.configFile."Equalizer.json" = {
    enable = true;
    source = ./Equalizer.json;
    target = "easyeffects/output/Equalizer.json";
  };
}
