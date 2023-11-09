{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.gnome;
in {
  options.modules.desktop.gnome = {
    enable = mkEnableOption "Whether to enable GNOME";
    minimal = mkEnableOption ''
      Whether to disable the installation of some GNOME packages.
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [{
        assertion = cfg.enable
          -> config.modules.desktop.displayManager.gdm.enable;
        message = "GNOME requires GDM as the display manager";
      }];
    }

    {
      services = {
        xserver = {
          enable = true;
          displayManager.gdm.enable = true;
          desktopManager.gnome.enable = true;
        };
        geoclue2.enable = true;
      };
    }

    (mkIf cfg.minimal {
      environment.gnome.excludePackages = (with pkgs; [ gnome-tour ])
        ++ (with pkgs.gnome; [ epiphany geary gnome-maps gnome-terminal ]);
    })
  ]);
}
