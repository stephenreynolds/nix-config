{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.apps.pavucontrol;
in {
  options.modules.apps.pavucontrol = {
    enable = mkEnableOption "Whether to install pavucontrol";
  };

  config = mkIf cfg.enable { hm.home.packages = [ pkgs.pavucontrol ]; };
}
