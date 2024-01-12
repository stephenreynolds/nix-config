{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.services.flatpak;
in
{
  options.my.services.flatpak = {
    enable = mkEnableOption "Whether to enable Flatpak";
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;

    users.groups.flatpak = { };
  };
}
