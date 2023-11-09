{ config, lib, ... }:
with lib;
let cfg = config.modules.services.media.mpd;
in {
  options.modules.services.media.mpd = {
    enable = mkOption {
      type = types.bool;
      default = config.modules.services.media.enable;
      description = "Whether to enable mpd";
    };
    musicDirectory = mkOption {
      type = types.str;
      default = "${config.hm.xdg.userDirs.music}";
      description = "The directory where mpd will look for music";
    };
    playlistDirectory = mkOption {
      type = types.str;
      default = "${config.hm.xdg.userDirs.music}/Playlists";
      description = "The directory where mpd will look for playlists";
    };
  };

  config = mkIf cfg.enable {
    hm.services.mpd = {
      enable = true;
      musicDirectory = "${cfg.musicDirectory}";
      playlistDirectory = "${cfg.playlistDirectory}";
      network.startWhenNeeded = true;
      extraConfig = ''
        log_file            "syslog"

        auto_update         "yes"
        auto_update_depth   "0"

        audio_output {
            type    "pipewire"
            name    "PipeWire Sound Server"
        }

        playlist_plugin {
            name "m3u"
            enabled "true"
        }

        playlist_plugin {
            name "pls"
            enabled "true"
        }

        audio_output {
            type                    "fifo"
            name                    "my_fifo"
            path                    "/tmp/mpd.fifo"
            format                  "44100:16:2"
        }
      '';
    };
  };
}
