{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types;
  cfg = config.modules.gaming.heroic-launcher;
in
{
  options.modules.gaming.heroic-launcher = {
    enable = mkEnableOption {
      type = types.bool;
      default = config.modules.gaming.enable;
      description = "Whether to install Heroic launcher";
    };
  };

  config = mkIf cfg.enable {
    hm.home.packages = [
      pkgs.herioc
    ];
  };
}
