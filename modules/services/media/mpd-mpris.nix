{ config, lib, ... }:
with lib;
let cfg = config.modules.services.media.mpd-mpris;
in {
  options.modules.services.media.mpd-mpris = {
    enable = mkOption {
      type = types.bool;
      default = config.modules.services.media.enable;
      description = "Whether to enable mpd-mpris";
    };
  };

  config = mkIf cfg.enable { hm.services.mpd-mpris.enable = true; };
}
