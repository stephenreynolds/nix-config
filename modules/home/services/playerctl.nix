{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.services.playerctl;
in
{
  options.my.services.playerctl = {
    enable = mkEnableOption "Whether to enable playerctl";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.playerctl ];

    services.playerctld.enable = true;
  };
}
