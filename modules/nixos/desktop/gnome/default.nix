{ config, lib, pkgs, ... }:

let
  cfg = config.my.desktop.gnome;
in
{
  options.my.desktop.gnome = {
    enable = lib.mkEnableOption "Whether to enable the GNOME desktop";
    minimal = lib.mkEnableOption "Whether to disable the installation of some GNOME packages";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      services = {
        xserver = {
	  enable = true;
	  displayManager.gdm.enable = true;
	  desktopManager.gnome.enable = true;
	};
      };
    }

    (lib.mkIf cfg.minimal {
      environment.gnome.excludePackages = (with pkgs; [ gnome-tour ])
        ++ (with pkgs.gnome; [ epiphany geary gnome-maps gnome-terminal ]);
    })
  ]);
}
