{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.gaming.lutris;
in {
  options.modules.gaming.lutris = {
    enable = mkEnableOption {
      type = types.bool;
      default = config.modules.gaming.enable;
      description = "Whether to install Lutris";
    };
  };

  config = mkIf cfg.enable { hm.home.packages = [ pkgs.lutris ]; };
}
