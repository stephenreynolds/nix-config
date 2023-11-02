{ config, lib, ... }:
with lib;
let cfg = config.modules.system.bluetooth;
in {
  options.modules.system.bluetooth = {
    enable = mkEnableOption "Enable Bluetooth";
    settings = mkOption {
      type = types.attrs;
      default = { };
      description =
        "Configuration for system-wide bluetooth (/etc/bluetooth/main.conf)";
    };
    powerOnBoot = mkEnableOption ''
      Whether to power up the default Bluetooth controller on boot
    '';
    blueman = {
      enable = mkEnableOption "Enable Bluetooth Manager";
      applet = mkEnableOption "Enable the Blueman applet";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.bluetooth = {
        enable = true;
        settings = cfg.settings;
        powerOnBoot = cfg.powerOnBoot;
      };
    }

    (mkIf cfg.blueman.enable {
      services.blueman.enable = true;
      hm.services.blueman-applet.enable = cfg.blueman.applet;
    })
  ]);
}
