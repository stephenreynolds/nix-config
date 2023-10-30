{ config, lib, ... }:
with lib;
let cfg = config.modules.services.keyring;
in {
  options.modules.services.keyring = {
    enable = mkEnableOption "Enable gnome-keyring service";
  };

  config = mkIf cfg.enable {
    hm.services.gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };
  };
}
