{ config, lib, pkgs, ... }:

let cfg = config.modules.services.media.mpdris2;
in {
  options.modules.services.media.mpdris2 = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.services.media.enable;
      description = "Whether to enable mpdris2";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hm.services.mpdris2 = {
        enable = true;
        mpd.musicDirectory = "${config.hm.xdg.userDirs.music}";
        multimediaKeys = true;
        notifications = true;
      };
    }

    (lib.mkIf config.modules.system.security.firejail.enable {
      programs.firejail.wrappedBinaries.mpdris2 = {
        executable = "${config.hm.services.mpdris2.package}/bin/mpDris2";
        profile = "${pkgs.firejail}/etc/firejail/mpDris2.profile";
      };
    })
  ]);
}
