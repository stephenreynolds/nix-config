{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.apps.vesktop;
in
{
  options.modules.apps.vesktop = {
    enable = mkEnableOption "Whether to install Vesktop, a Discord client";
  };

  config = mkIf cfg.enable {
    hm.home.packages = [ pkgs.vesktop ];

    modules.system.persist.state.home.directories = [ ".config/vesktop" ];
  };
}
