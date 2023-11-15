{ config, lib, ... }:

let cfg = config.modules.services.flatpak;
in {
  options.modules.services.flatpak = {
    enable = lib.mkEnableOption "Whether to enable Flatpak";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;

    users.groups.flatpak = { };
  };
}
