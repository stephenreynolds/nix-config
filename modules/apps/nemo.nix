{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.nemo;
in {
  options.modules.apps.nemo = {
    enable = lib.mkEnableOption "Whether to install the Nemo file manager";
    default =
      lib.mkEnableOption "Whether Nemo should be the default file manager";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hm.home.packages = with pkgs; [
        cinnamon.nemo-with-extensions
        cinnamon.nemo-fileroller
      ];
    }

    (lib.mkIf cfg.default {
      hm.xdg.mimeApps.defaultApplications."inode/directory" = "nemo.desktop";
    })
  ]);
}
