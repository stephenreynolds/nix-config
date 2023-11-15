{ config, lib, ... }:

let cfg = config.modules.desktop.displayManager.gdm;
in {
  options.modules.desktop.displayManager.gdm = {
    enable = lib.mkEnableOption "Whether to enable GDM";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [{
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
  }]);
}
