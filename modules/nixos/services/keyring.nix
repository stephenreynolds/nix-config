{ config, lib, ... }:

let cfg = config.my.services.keyring;
in {
  options.my.services.keyring = {
    enable = lib.mkEnableOption "Enable gnome-keyring service";
  };

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
  };
}
