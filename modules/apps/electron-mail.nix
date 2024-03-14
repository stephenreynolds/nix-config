{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.modules.apps.electron-mail;
in
{
  options.modules.apps.electron-mail = {
    enable = mkEnableOption "Whether to install ElectronMail";
    autostart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start ElectronMail on login";
    };
  };

  config = mkIf cfg.enable {
    hm.home.packages = [ pkgs.my.electron-mail ];

    hm.xdg.configFile."autostart/electron-mail.desktop" = {
      enable = cfg.autostart;
      text = ''
        [Desktop Entry]
        Type=Application
        Exec=${pkgs.my.electron-mail}/bin/electron-mail
        Terminal=false
        StartupWMClass=electron-mail
        X-AppImage-Version=5.2.2
        Name=ElectronMail
        Icon=electron-mail
        Comment=Unofficial ProtonMail Desktop App
        Categories=Office;
        X-GNOME-Autostart-enabled=true
      '';
    };

    modules.system.persist.state.home.directories = [ ".config/electron-mail" ];
  };
}
