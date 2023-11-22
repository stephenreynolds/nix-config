{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.celluloid;
in {
  options.modules.apps.celluloid = {
    enable = lib.mkEnableOption "Whether to install the Celluloid media player";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { hm.home.packages = [ pkgs.celluloid ]; }

    (lib.mkIf config.modules.system.security.firejail.enable {
      programs.firejail.wrappedBinaries.celluloid = {
        executable = "${pkgs.celluloid}/bin/celluloid";
        profile = "${pkgs.firejail}/etc/firejail/celluloid.profile";
      };
    })
  ]);
}
