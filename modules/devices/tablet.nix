{ config, lib, ... }:

let cfg = config.modules.devices.tablet;
in {
  options.modules.devices.tablet = {
    enable = lib.mkEnableOption "Enable drivers for drawing tablets";
    digimend = {
      enable = lib.mkEnableOption ''
        Whether to enable the digimend drivers for Huion/XP-Pen/etc. tablets
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    }

    (lib.mkIf cfg.digimend.enable { services.xserver.digimend.enable = true; })
  ]);
}
