{ pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ mozc ];
  };

  environment.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
    QT_IM_MODULE = "ibus";
  };
}
