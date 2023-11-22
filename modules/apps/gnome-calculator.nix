{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.gnome-calculator;
in {
  options.modules.apps.gnome-calculator = {
    enable = lib.mkEnableOption "Whether to install GNOME Calculator";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gnome.gnome-calculator;
      description = "The package to use for GNOME Calculator";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { hm.home.packages = [ cfg.package ]; }

    (lib.mkIf config.modules.system.security.firejail.enable {
      programs.firejail.wrappedBinaries.gnome-calculator = {
        executable = "${cfg.package}/bin/gnome-calculator";
        profile = "${pkgs.firejail}/etc/firejail/gnome-calculator.profile";
      };
    })
  ]);
}
