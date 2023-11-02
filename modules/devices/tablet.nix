{ config, lib, ... }:
with lib;
let cfg = config.modules.devices.tablet;
in {
  options.modules.devices.tablet = {
    enable = mkEnableOption "Enable drivers for drawing tablets";
    digimend = {
      enable = mkEnableOption ''
        Whether to enable the digimend drivers for Huion/XP-Pen/etc. tablets
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    }

    (mkIf cfg.digimend.enable { services.xserver.digimend.enable = true; })
  ]);
}
