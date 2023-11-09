{ config, lib, ... }:
with lib;
let cfg = config.modules.services.media.mpdris2;
in {
  options.modules.services.media.mpdris2 = {
    enable = mkOption {
      type = types.bool;
      default = config.modules.services.media.enable;
      description = "Whether to enable mpdris2";
    };
  };

  config = mkIf cfg.enable {
    hm.services.mpdris2 = {
      enable = true;
      mpd.musicDirectory = "${config.hm.xdg.userDirs.music}";
      multimediaKeys = true;
      notifications = true;
    };
  };
}
