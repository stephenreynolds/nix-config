{ config, lib, ... }:

let cfg = config.modules.services.media.mpdris2;
in {
  options.modules.services.media.mpdris2 = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.services.media.enable;
      description = "Whether to enable mpdris2";
    };
  };

  config = lib.mkIf cfg.enable {
    hm.services.mpdris2 = {
      enable = true;
      mpd.musicDirectory = "${config.hm.xdg.userDirs.music}";
      multimediaKeys = true;
      notifications = true;
    };
  };
}
