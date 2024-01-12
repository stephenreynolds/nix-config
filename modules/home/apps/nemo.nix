{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.my.apps.nemo;
in
{
  options.my.apps.nemo = {
    enable = mkEnableOption "Whether to install the Nemo file manager";
    default = mkEnableOption "Whether Nemo should be the default file manager";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [
        cinnamon.nemo-with-extensions
        cinnamon.nemo-fileroller
      ];
    }

    (mkIf cfg.default {
      xdg.mimeApps.defaultApplications."inode/directory" = "nemo.desktop";
    })
  ]);
}
