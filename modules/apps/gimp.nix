{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.gimp;
in {
  options.modules.apps.gimp = {
    enable = lib.mkEnableOption "Whether to install GIMP";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gimp-with-plugins;
      description = "The GIMP package to install";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { hm.home.packages = [ cfg.package ]; }

    (lib.mkIf config.modules.system.security.firejail.enable {
      programs.firejail.wrappedBinaries.gimp = {
        executable = "${cfg.package}/bin/gimp";
        profile = "${pkgs.firejail}/etc/firejail/gimp-2.10.profile";
      };
    })
  ]);
}
