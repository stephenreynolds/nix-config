{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.services.geoclue;
in
{
  options.my.services.geoclue = {
    enable = mkEnableOption "Whether to enable the GeoClue 2 daemon";
  };

  config = mkIf cfg.enable { services.geoclue2.enable = true; };
}
