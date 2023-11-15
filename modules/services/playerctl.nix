{ config, lib, pkgs, ... }:

let cfg = config.modules.services.playerctl;
in {
  options.modules.services.playerctl = {
    enable = lib.mkEnableOption "Whether to enable playerctl";
  };

  config = lib.mkIf cfg.enable {
    hm.home.packages = [ pkgs.playerctl ];

    hm.services.playerctld.enable = true;
  };
}
