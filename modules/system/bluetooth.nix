{ config, lib, ... }:

let cfg = config.modules.system.bluetooth;
in {
  options.modules.system.bluetooth = {
    enable = lib.mkEnableOption "Enable Bluetooth";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description =
        "Configuration for system-wide bluetooth (/etc/bluetooth/main.conf)";
    };
    powerOnBoot = lib.mkEnableOption ''
      Whether to power up the default Bluetooth controller on boot
    '';
    blueman = {
      enable = lib.mkEnableOption "Enable Bluetooth Manager";
      applet = lib.mkEnableOption "Enable the Blueman applet";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hardware.bluetooth = {
        enable = true;
        settings = cfg.settings;
        powerOnBoot = cfg.powerOnBoot;
      };
    }

    (lib.mkIf cfg.blueman.enable {
      services.blueman.enable = true;
      hm.services.blueman-applet.enable = cfg.blueman.applet;
    })
  ]);
}
