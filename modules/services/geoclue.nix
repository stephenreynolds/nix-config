{ config, lib, ... }:
with lib;
let cfg = config.modules.services.geoclue;
in {
  options.modules.services.geoclue = {
    enable = mkEnableOption "Whether to enable the GeoClue 2 daemon";
  };

  config = mkIf cfg.enable { services.geoclue2.enable = true; };
}
