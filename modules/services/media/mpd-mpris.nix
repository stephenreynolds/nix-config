{ config, lib, ... }:

let cfg = config.modules.services.media.mpd-mpris;
in {
  options.modules.services.media.mpd-mpris = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.services.media.enable;
      description = "Whether to enable mpd-mpris";
    };
  };

  config = lib.mkIf cfg.enable { hm.services.mpd-mpris.enable = true; };
}
