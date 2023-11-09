{ config, lib, ... }:
with lib;
let cfg = config.modules.desktop.displayManager.gdm;
in {
  options.modules.desktop.displayManager.gdm = {
    enable = mkEnableOption "Whether to enable GDM";
  };

  config = mkIf cfg.enable (mkMerge [{
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
  }]);
}
