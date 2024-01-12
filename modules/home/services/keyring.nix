{ config, lib, ... }:

let cfg = config.my.services.keyring;
in {
  options.my.services.keyring = {
    enable = lib.mkEnableOption "Enable gnome-keyring service";
  };

  config = lib.mkIf cfg.enable {
    services.gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };
  };
}
