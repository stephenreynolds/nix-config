{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkMerge types;
  cfg = config.modules.apps.vesktop;
in
{
  options.modules.apps.vesktop = {
    enable = mkEnableOption "Whether to install Vesktop, a Discord client";
    autostart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start Vesktop on login";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.home.packages = [ pkgs.vesktop ];

      modules.system.persist.state.home.directories = [ ".config/vesktop" ];
    }

    (mkIf cfg.autostart {
      hm.xdg.configFile."autostart/vesktop.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Version=1.0
        Name=Vencord
        Comment=Vencord autostart script
        Exec=sh -c "${pkgs.vesktop}/bin/vesktop --start-minimized"
        Terminal=false
        StartupNotify=false
      '';
    })
  ]);
}
