{ config, lib, inputs, ... }:

let cfg = config.modules.system.pipewire;
in {
  imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];

  options.modules.system.pipewire = {
    enable = lib.mkEnableOption "Enable PipeWire";
    lowLatency = lib.mkEnableOption "Reduce audio latency";
    support32Bit = lib.mkEnableOption "Enable 32-bit alsa support";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = cfg.support32Bit;
        pulse.enable = true;
        jack.enable = true;
      };

      hardware.pulseaudio.enable = false;

      modules.system.persist.state.home.directories =
        [ ".local/state/wireplumber" ];
    }

    (lib.mkIf cfg.lowLatency {
      services.pipewire.lowLatency.enable = true;
      security.rtkit.enable = true;
    })
  ]);
}
