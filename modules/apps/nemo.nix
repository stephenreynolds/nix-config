{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.apps.nemo;
in {
  options.modules.apps.nemo = {
    enable = mkEnableOption "Whether to install the Nemo file manager";
    default = mkEnableOption "Whether Nemo should be the default file manager";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.home.packages = with pkgs; [
        cinnamon.nemo-with-extensions
        cinnamon.nemo-fileroller
      ];
    }

    (mkIf cfg.default {
      hm.xdg.mimeApps.defaultApplications."inode/directory" = "nemo.desktop";
    })
  ]);
}
