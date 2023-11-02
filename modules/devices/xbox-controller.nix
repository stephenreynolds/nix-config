{ config, lib, ... }:
with lib;
let cfg = config.modules.devices.xboxController;
in {
  options.modules.devices.xboxController = {
    enable = mkEnableOption "Whether to install drivers for Xbox controllers";
  };

  config = mkIf cfg.enable { hardware.xpadneo.enable = true; };
}
