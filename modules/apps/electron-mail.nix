{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.apps.electron-mail;
in {
  options.modules.apps.electron-mail = {
    enable = mkEnableOption "Whether to install ElectronMail";
    autostart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start ElectronMail on login";
    };
  };

  config = mkIf cfg.enable {
    hm.home.packages = [ pkgs.electron-mail ];

    hm.xdg.configFile."autostart/electron-mail.desktop" = {
      enable = cfg.autostart;
      text = ''
        [Desktop Entry]
        Type=Application
        Exec=electron-mail --js-flags="--max-old-space-size=12288" %U
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
