{ config, lib, ... }:
with lib;
let cfg = config.modules.services.flatpak;
in {
  options.modules.services.flatpak = {
    enable = mkEnableOption "Whether to enable Flatpak";
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;

    users.groups.flatpak = { };
  };
}
