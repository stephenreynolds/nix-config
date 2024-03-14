{ config, lib, ... }:

let cfg = config.modules.apps.imv;
in {
  options.modules.apps.imv = {
    enable = lib.mkEnableOption "Whether to install the imv image viewer";
    default =
      lib.mkEnableOption "Whether to set imv as the default image viewer";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { hm.programs.imv.enable = true; }

    (lib.mkIf cfg.default {
      hm.xdg.mimeApps.defaultApplications = {
        "image/avif" = "imv-folder;imv.desktop";
        "image/bmp" = "imv-folder;imv.desktop";
        "image/gif" = "imv-folder;imv.desktop";
        "image/heif" = "imv-folder;imv.desktop";
        "image/jpeg" = "imv-folder;imv.desktop";
        "image/jpg" = "imv-folder;imv.desktop";
        "image/pjpeg" = "imv-folder;imv.desktop";
        "image/png" = "imv-folder;imv.desktop";
        "image/svg+xml" = "imv-folder;imv.desktop";
        "image/tiff" = "imv-folder;imv.desktop";
        "image/x-bmp" = "imv-folder;imv.desktop";
        "image/x-pcx" = "imv-folder;imv.desktop";
        "image/x-png" = "imv-folder;imv.desktop";
        "image/x-portable-anymap" = "imv-folder;imv.desktop";
        "image/x-portable-bitmap" = "imv-folder;imv.desktop";
        "image/x-portable-graymap" = "imv-folder;imv.desktop";
        "image/x-portable-pixmap" = "imv-folder;imv.desktop";
        "image/x-tga" = "imv-folder;imv.desktop";
        "image/x-xbitmap" = "imv-folder;imv.desktop";
      };
    })
  ]);
}
