{ config, lib, ... }:
with lib;
let cfg = config.modules.system.networking;
in {
  options.modules.system.networking = {
    networkManager.enable = mkEnableOption "Enable NetworkManager";
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
        wifi.backend = mkDefault "wpa_supplicant";
      };
    })
  ];
}
