{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.modules.devices.logitech;
in
{
  options.modules.devices.logitech = {
    enable = mkEnableOption "Whether to enable support for Logitech Wireless Devices.";
    enableGraphical = mkOption {
      type = types.bool;
      default = cfg.enable;
      description = "Enable graphical support applications.";
    };
  };

  config = mkIf cfg.enable {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = cfg.enableGraphical;
    };
  };
}
