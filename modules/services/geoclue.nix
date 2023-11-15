{ config, lib, ... }:

let cfg = config.modules.services.geoclue;
in {
  options.modules.services.geoclue = {
    enable = lib.mkEnableOption "Whether to enable the GeoClue 2 daemon";
  };

  config = lib.mkIf cfg.enable { services.geoclue2.enable = true; };
}
