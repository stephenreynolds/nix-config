{ config, lib, pkgs, ... }:

let cfg = config.modules.desktop.gnome;
in {
  options.modules.desktop.gnome = {
    enable = lib.mkEnableOption "Whether to enable GNOME";
    minimal = lib.mkEnableOption ''
      Whether to disable the installation of some GNOME packages.
    '';
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
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

    (lib.mkIf cfg.minimal {
      environment.gnome.excludePackages = (with pkgs; [ gnome-tour ])
        ++ (with pkgs.gnome; [ epiphany geary gnome-maps gnome-terminal ]);
    })
  ]);
}
