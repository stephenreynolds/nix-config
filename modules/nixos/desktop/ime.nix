{ config, lib, pkgs, ... }:

let cfg = config.my.desktop.ime;
in {
  options.my.desktop.ime = {
    enable = lib.mkEnableOption "Whether to enable Japanese IME";
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ mozc ];
    };

    environment.sessionVariables = {
      GTK_IM_MODULE = "ibus";
      XMODIFIERS = "@im=ibus";
      QT_IM_MODULE = "ibus";
    };
  };
}
