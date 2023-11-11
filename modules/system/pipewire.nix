{ config, lib, inputs, ... }:
with lib;
let cfg = config.modules.system.pipewire;
in {
  imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];

  options.modules.system.pipewire = {
    enable = mkEnableOption "Enable PipeWire";
    lowLatency = mkEnableOption "Reduce audio latency";
    support32Bit = mkEnableOption "Enable 32-bit alsa support";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = cfg.support32Bit;
        pulse.enable = true;
        jack.enable = true;
      };

      hardware.pulseaudio.enable = false;
    }

    (mkIf cfg.lowLatency {
      services.pipewire.lowLatency.enable = true;
      security.rtkit.enable = true;
    })
  ]);
}
