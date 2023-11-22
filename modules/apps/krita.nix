{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.krita;
in {
  options.modules.apps.krita = {
    enable = lib.mkEnableOption "Whether to install Krita";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.krita;
      description = "The Krita package to install";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { hm.home.packages = [ cfg.package ]; }

    (lib.mkIf config.modules.system.security.firejail.enable {
      programs.firejail.wrappedBinaries.krita = {
        executable = "${cfg.package}/bin/krita";
        profile = "${pkgs.firejail}/etc/firejail/krita.profile";
      };
    })
  ]);
}
