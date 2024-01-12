{ config, lib, ... }:

let cfg = config.my.desktop;
in {
  options.my.desktop = {
    enable = lib.mkEnableOption "Enable a desktop environment";
    pam = {
      gtklock = lib.mkEnableOption "Whether to allow authentication using gtklock";
      swaylock = lib.mkEnableOption "Whether to allow authentication using swaylock";
    };
  };

  config = lib.mkIf cfg.enable {
    security.polkit.enable = true;

    security.pam.services = {
      gtklock = lib.mkIf cfg.pam.gtklock { };
      swaylock = lib.mkIf cfg.pam.swaylock { };
    };
  };
}
