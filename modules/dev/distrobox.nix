{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.dev.distrobox;
in
{
  options.modules.dev.distrobox = {
    enable = mkEnableOption "Whether to enable Distrobox";
  };

  config = mkIf cfg.enable {
    hm.home.packages = [ pkgs.distrobox ];
  };
}
