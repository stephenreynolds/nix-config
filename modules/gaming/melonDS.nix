{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.gaming.melonDS;
in
{
  options.modules.gaming.melonDS = {
    enable = mkEnableOption "Whether to enable melonDS";
  };

  config = mkIf cfg.enable {
    hm.home.packages = [ pkgs.melonDS ];

    modules.system.persist.state.home.directories = [
      ".config/melonDS"
    ];
  };
}
