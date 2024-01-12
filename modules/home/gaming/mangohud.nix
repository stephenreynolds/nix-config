{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.gaming.mangohud;
in
{
  options.my.gaming.mangohud = {
    enable = mkEnableOption "Whether to install MangoHud";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.mangohud ];
  };
}
