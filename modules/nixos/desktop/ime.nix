{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkMerge types;
  cfg = config.my.desktop.ime;
in
{
  options.my.desktop.ime = {
    enable = mkEnableOption "Whether to enable Japanese IME";
    method = mkOption {
      type = types.enum [ "ibus" "fcitx5" ];
      default = "ibus";
      description = "The input method to use";
    };
    fcitx5 = {
      wayland = mkEnableOption "Whether to enable the Wayland frontend";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.method == "ibus") {
      i18n.inputMethod = {
        enabled = "ibus";
        ibus.engines = with pkgs.ibus-engines; [ mozc ];
      };

      environment.sessionVariables = {
        GTK_IM_MODULE = "ibus";
        XMODIFIERS = "@im=ibus";
        QT_IM_MODULE = "ibus";
      };
    })

    (mkIf (cfg.method == "fcitx5") {
      i18n.inputMethod = {
        enabled = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
        ];
      };

      i18n.inputMethod.fcitx5.waylandFrontend = cfg.fcitx5.wayland;
    })
  ]);
}
