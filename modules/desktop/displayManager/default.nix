{ config, ... }:
let cfg = config.modules.desktop.displayManager;
in {
  config.assertions = [{
    assertion = !(cfg.gdm.enable && cfg.sddm.enable && cfg.regreet.enable);
    message = "Only one display manager can be enabled at a time";
  }];
}
