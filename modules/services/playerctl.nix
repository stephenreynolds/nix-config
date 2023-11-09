{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.services.playerctl;
in {
  options.modules.services.playerctl = {
    enable = mkEnableOption "Whether to enable playerctl";
  };

  config = mkIf cfg.enable {
    hm.home.packages = [ pkgs.playerctl ];

    hm.services.playerctld.enable = true;
  };
}
