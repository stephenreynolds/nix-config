{ config, lib, ... }:
with lib;
let cfg = config.modules.networking;
in {
  options.modules.networking = {
    networkManager.enable = mkEnableOption (mdDoc "Enable NetworkManager");
  };

  config = mkMerge [
    { networking.firewall.enable = true; }

    (mkIf cfg.networkManager.enable {
      systemd.services.NetworkManager-wait-online.enable = false;

      networking.networkmanager = {
        enable = mkDefault true;
        wifi.backend = mkDefault "wpa_supplicant";
      };
    })
  ];
}
