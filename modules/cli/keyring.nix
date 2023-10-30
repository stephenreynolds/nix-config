{ config, lib, ... }:
with lib;
let cfg = config.modules.cli.keyring;
in {
  options.modules.cli.keyring = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable keyring service";
    };
  };

  config = mkIf cfg.enable {
    hm.services.gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };
  };
}
