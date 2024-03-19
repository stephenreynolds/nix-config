{ config, lib, ... }:

let cfg = config.modules.services.keyring;
in {
  options.modules.services.keyring = {
    enable = lib.mkEnableOption "Enable gnome-keyring service";
  };

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    modules.system.persist.state.home.directories = [{
      directory = ".local/share/keyrings";
      mode = "0700";
    }];
  };
}
