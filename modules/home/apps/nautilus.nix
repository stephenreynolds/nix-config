{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.apps.nautilus;
in
{
  options.my.apps.nautilus = {
    enable = mkEnableOption "Whether to install the Nautilus file manager";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome.nautilus
      gnome.sushi
      nautilus-open-any-terminal
    ];
  };
}
