{ config, lib, ... }:

let cfg = config.modules.system.security.apparmor;
in {
  options.modules.system.security.apparmor = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable AppArmor";
    };
  };

  config = lib.mkIf cfg.enable {
    security.apparmor.enable = true;

    services.dbus.apparmor = "required";
  };
}
