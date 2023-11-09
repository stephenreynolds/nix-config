{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.apps.nautilus;
in {
  options.modules.apps.nautilus = {
    enable = mkEnableOption "Whether to install the Nautilus file manager";
  };

  config = mkIf cfg.enable {
    hm.home.packages = with pkgs; [
      gnome.nautilus
      gnome.sushi
      nautilus-open-any-terminal
    ];
  };
}
