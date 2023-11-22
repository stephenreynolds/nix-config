{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.gnome-clocks;
in {
  options.modules.apps.gnome-clocks = {
    enable = lib.mkEnableOption "Whether to install GNOME Clocks";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gnome.gnome-clocks;
      description = "The package to use for GNOME Clocks";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { hm.home.packages = [ cfg.package ]; }

    (lib.mkIf config.modules.system.security.firejail.enable {
      programs.firejail.wrappedBinaries.gnome-clocks = {
        executable = "${cfg.package}/bin/gnome-clocks";
        profile = "${pkgs.firejail}/etc/firejail/gnome-clocks.profile";
      };
    })
  ]);
}
