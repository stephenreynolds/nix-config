{ config, lib, ... }:
with lib;
let cfg = config.modules.system.networking;
in {
  options.modules.system.networking = {
    networkManager = {
      enable = mkEnableOption "Enable NetworkManager";
      backend = mkOption {
        type = types.enum [ "wpa_supplicant" "iwd" ];
        default = "wpa_supplicant";
        description = "The backend to use for WiFi connections";
      };
      randomizeMac = mkEnableOption "Whether to randomize MAC address";
    };
    firewall.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the firewall";
    };
  };

  config = mkMerge [
    { networking.firewall.enable = cfg.firewall.enable; }

    (mkIf cfg.networkManager.enable {
      systemd.services.NetworkManager-wait-online.enable = false;

      networking.networkmanager = {
        enable = mkDefault true;
        wifi = {
          backend = cfg.networkManager.backend;
          macAddress = if cfg.randomizeMac then "random" else "preserve";
        };
      };
    })
  ];
}
