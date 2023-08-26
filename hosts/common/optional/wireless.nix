{ config, ... }:
{
  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  networking.wireless = {
    enable = true;
    fallbackToWPA2 = false;
    environmentFile = config.sops.secrets.wireless.path;
    networks = {
      "Mordor" = {
        psk = "@MORDOR@";
      };
    };

    iwd = {
      enable = true;
    };

    allowAuxiliaryImperativeNetworks = true;
    userControlled = {
      enable = true;
      group = "network";
    };
    extraConfig = ''
      update_config=1
    '';
  };

  users.groups.network = { };
}
