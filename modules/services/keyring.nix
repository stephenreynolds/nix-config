{ config, lib, ... }:

let cfg = config.modules.services.keyring;
in {
  options.modules.services.keyring = {
    enable = lib.mkEnableOption "Enable gnome-keyring service";
  };

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    hm.services.gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };

    modules.system.persist.state.home.directories = [
      ".local/share/keyrings"
    ];
  };
}
