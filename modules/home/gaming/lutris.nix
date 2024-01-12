{ config, lib, pkgs, ... }:

let
  inherit (lib) types mkEnableOption mkIf;
  cfg = config.my.gaming.lutris;
in
{
  options.my.gaming.lutris = {
    enable = mkEnableOption {
      type = types.bool;
      default = config.my.gaming.enable;
      description = "Whether to install Lutris";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.lutris ];
  };
}
