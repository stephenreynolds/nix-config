{ config, lib, pkgs, ... }:

let cfg = config.my.apps.electron-mail;
in {
  options.my.apps.electron-mail = {
    enable = lib.mkEnableOption "Whether to install ElectronMail";
    autostart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to start ElectronMail on login";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.my.electron-mail ];

    xdg.configFile."autostart/electron-mail.desktop" = {
      enable = cfg.autostart;
      text = ''
        [Desktop Entry]
        Type=Application
        Exec=gtk-launch electron-mail
        Terminal=false
        StartupWMClass=electron-mail
        X-AppImage-Version=5.1.8
        Name=ElectronMail
        Icon=electron-mail
        Comment=Unofficial ProtonMail Desktop App
        Categories=Office;
        X-GNOME-Autostart-enabled=true
      '';
    };
  };
}
