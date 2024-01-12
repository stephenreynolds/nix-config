{ config, lib, ... }:

let cfg = config.my.devices.xboxController;
in {
  options.my.devices.xboxController = {
    enable = lib.mkEnableOption "Whether to install drivers for Xbox controllers";
  };

  config = lib.mkIf cfg.enable { hardware.xpadneo.enable = true; };
}
