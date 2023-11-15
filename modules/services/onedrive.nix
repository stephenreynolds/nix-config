{ config, lib, ... }:
with lib;
let cfg = config.modules.services.onedrive;
in {
  options.modules.services.onedrive = {
    enable = mkEnableOption "Whether to enable the OneDrive client";
    syncDir = mkOption {
      type = types.str;
      default = "${config.hm.home.homeDirectory}/.onedrive";
      description = "The directory to sync OneDrive to";
    };
    logging = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable logging";
      };
    };
    symlinkUserDirs = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to symlink the XDG user directories to the respective
          directories in OneDrive.
        '';
      };
      documents = {
        enable = mkOption {
          type = types.bool;
          default = cfg.symlinkUserDirs.enable;
          description = "Whether to symlink the documents directory";
        };
        source = mkOption {
          type = types.str;
          default = "Documents";
          description = ''
            The location of the documents directory relative to HOME.
          '';
        };
        target = mkOption {
          type = types.str;
          default = "Documents";
          description = "The location of the documents directory in OneDrive";
        };
      };
      music = {
        enable = mkOption {
          type = types.bool;
          default = cfg.symlinkUserDirs.enable;
          description = "Whether to symlink the music directory";
        };
        source = mkOption {
          type = types.str;
          default = "Music";
          description = ''
            The location of the music directory relative to HOME.
          '';
        };
        target = mkOption {
          type = types.str;
          default = "Music";
          description = "The location of the music directory in OneDrive";
        };
      };
      pictures = {
        enable = mkOption {
          type = types.bool;
          default = cfg.symlinkUserDirs.enable;
          description = "Whether to symlink the pictures directory";
        };
        source = mkOption {
          type = types.str;
          default = "Pictures";
          description = ''
            The location of the pictures directory relative to HOME.
          '';
        };
        target = mkOption {
          type = types.str;
          default = "Pictures";
          description = "The location of the pictures directory in OneDrive";
        };
      };
      videos = {
        enable = mkOption {
          type = types.bool;
          default = cfg.symlinkUserDirs.enable;
          description = "Whether to symlink the videos directory";
        };
        source = mkOption {
          type = types.str;
          default = "Videos";
          description = ''
            The location of the videos directory relative to HOME.
          '';
        };
        target = mkOption {
          type = types.str;
          default = "Videos";
          description = "The location of the videos directory in OneDrive";
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.onedrive.enable = true;

      hm.xdg.configFile."onedrive" = {
        enable = true;
        target = "onedrive/config";
        text = ''
          sync_dir = "${cfg.syncDir}"
          enable_logging = "${if cfg.logging.enable then "true" else "false"}"
        '';
      };
    }

    (mkIf cfg.logging.enable {
      systemd.tmpfiles.rules = [ "d /var/log/onedrive 0775 root users" ];
    })

    (mkIf cfg.symlinkUserDirs.enable {
      # Symlink user directories
      hm.home.file = mkIf cfg.symlinkUserDirs.enable {
        "Documents" = {
          enable = cfg.symlinkUserDirs.documents.enable;
          source = config.hm.lib.file.mkOutOfStoreSymlink
            "${cfg.syncDir}/${cfg.symlinkUserDirs.documents.target}";
          target = "${cfg.symlinkUserDirs.documents.source}";
        };

        "Music" = {
          enable = cfg.symlinkUserDirs.music.enable;
          source = config.hm.lib.file.mkOutOfStoreSymlink
            "${cfg.syncDir}/${cfg.symlinkUserDirs.music.target}";
          target = "${cfg.symlinkUserDirs.music.source}";
        };

        "Pictures" = {
          enable = cfg.symlinkUserDirs.pictures.enable;
          source = config.hm.lib.file.mkOutOfStoreSymlink
            "${cfg.syncDir}/${cfg.symlinkUserDirs.pictures.target}";
          target = "${cfg.symlinkUserDirs.pictures.source}";
        };

        "Videos" = {
          enable = cfg.symlinkUserDirs.videos.enable;
          source = config.hm.lib.file.mkOutOfStoreSymlink
            "${cfg.syncDir}/${cfg.symlinkUserDirs.videos.target}";
          target = "${cfg.symlinkUserDirs.videos.source}";
        };
      };

      # Set XDG user directories to OneDrive directories
      hm.xdg.userDirs = mkIf cfg.symlinkUserDirs.enable {
        documents = mkIf cfg.symlinkUserDirs.documents.enable
          "${cfg.syncDir}/${cfg.symlinkUserDirs.documents.target}";

        music = mkIf cfg.symlinkUserDirs.music.enable
          "${cfg.syncDir}/${cfg.symlinkUserDirs.music.target}";

        pictures = mkIf cfg.symlinkUserDirs.pictures.enable
          "${cfg.syncDir}/${cfg.symlinkUserDirs.pictures.target}";

        videos = mkIf cfg.symlinkUserDirs.videos.enable
          "${cfg.syncDir}/${cfg.symlinkUserDirs.videos.target}";
      };
    })
  ]);
}
