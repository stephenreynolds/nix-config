{
  services.easyeffects = {
    enable = true;
  };

  xdg.configFile."Equalizer.json" = {
    enable = true;
    source = ./Equalizer.json;
    target = "easyeffects/output/Equalizer.json";
  };

  xdg.configFile."corsair_virtuoso_gaming_headset.json" = {
    enable = true;
    target = "easyeffects/autoload/output/corsair_virtuoso_gaming_headset.json";
    text = ''
      {
        "device": "alsa_output.usb-Corsair_CORSAIR_VIRTUOSO_USB_Gaming_Headset_149b30ac000600fc-00.analog-stereo",
        "device-description": "CORSAIR VIRTUOSO USB Gaming Headset Analog Stereo",
        "device-profile": "analog-output-headphones",
        "preset-name": "Equalizer"
      }
    '';
  };
}
