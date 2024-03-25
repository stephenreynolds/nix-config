{ config, lib, pkgs, ... }:

let cfg = config.modules.desktop.ime;
in {
  options.modules.desktop.ime = {
    enable = lib.mkEnableOption "Whether to enable Japanese IME";
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ mozc ];
    };

    environment.sessionVariables = {
      GLFW_IM_MODULE = "ibus";
      GTK_IM_MODULE = "ibus";
      QT_IM_MODULE = "ibus";
      XMODIFIERS = "@im=ibus";
    };

    modules.system.persist.state.home.directories = [ ".config/mozc" ];
  };
}
