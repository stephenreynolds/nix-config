{ config, lib, ... }:

let cfg = config.modules.devices.xboxController;
in {
  options.modules.devices.xboxController = {
    enable = lib.mkEnableOption "Whether to install drivers for Xbox controllers";
  };

  config = lib.mkIf cfg.enable { hardware.xpadneo.enable = true; };
}
