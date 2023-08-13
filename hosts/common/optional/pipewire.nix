{
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.etc = {
    "pipewire/pipewire.conf.d/92-low-latency.conf".text = ''
      context.properties = {
        default.clock.rate = 48000
        default.clock.quantum = 32
        default.clock.min-quantum = 32
        default.clock.max-quantum = 32
      }
    '';
  };
}
