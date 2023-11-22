{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.deluge;
in {
  options.modules.apps.deluge = {
    enable = lib.mkEnableOption "Whether to install Deluge";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.deluge;
      description = "The Deluge package to install";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { hm.home.packages = [ cfg.package ]; }

    (lib.mkIf config.modules.system.security.firejail.enable {
      programs.firejail.wrappedBinaries.deluge = {
        executable = "${cfg.package}/bin/deluge";
        profile = "${pkgs.firejail}/etc/firejail/deluge.profile";
      };
    })
  ]);
}
