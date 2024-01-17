{ config, lib, ... }:

let cfg = config.modules.services.media.mpd;
in {
  options.modules.services.media.mpd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.services.media.enable;
      description = "Whether to enable mpd";
    };
    musicDirectory = lib.mkOption {
      type = lib.types.str;
      default = "${config.hm.xdg.userDirs.music}";
      description = "The directory where mpd will look for music";
    };
    playlistDirectory = lib.mkOption {
      type = lib.types.str;
      default = "${config.hm.xdg.userDirs.music}/Playlists";
      description = "The directory where mpd will look for playlists";
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra configuration for mpd";
    };
  };

  config = lib.mkIf cfg.enable {
    hm.services.mpd = {
      enable = true;
      musicDirectory = "${cfg.musicDirectory}";
      playlistDirectory = "${cfg.playlistDirectory}";
      network.startWhenNeeded = true;
      extraConfig =
        ''
          log_level           "warning"

          # Put MPD into pause mode instead of starting playback after startup
          restore_paused      "yes"

          # Auto update the music database when files are changed in music_directory
          auto_update         "yes"
        '' +
        lib.optionalString config.services.pipewire.enable ''
          audio_output {
              type    "pipewire"
              name    "PipeWire Sound Server"
          }
        '' +
        cfg.extraConfig;
    };
  };
}
