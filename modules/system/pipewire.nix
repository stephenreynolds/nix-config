{ config, lib, inputs, ... }:
with lib;
let cfg = config.modules.system.pipewire;
in {
  imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];

  options.modules.system.pipewire = {
    enable = mkEnableOption "Enable PipeWire";
    lowLatency = mkEnableOption "Reduce audio latency";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      security.rtkit.enable = true;

      hardware.pulseaudio.enable = false;
    }

    (mkIf cfg.lowLatency { services.pipewire.lowLatency.enable = true; })
  ]);
}
