{ config, ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.xdg.userDirs.music}";
    playlistDirectory = "${config.xdg.userDirs.music}/Playlists";
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
}
