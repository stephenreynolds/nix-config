{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.pavucontrol;
in {
  options.modules.apps.pavucontrol = {
    enable = lib.mkEnableOption "Whether to install pavucontrol";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { hm.home.packages = [ pkgs.pavucontrol ]; }

    (lib.mkIf config.modules.system.security.firejail.enable {
      programs.firejail.wrappedBinaries.pavucontrol = {
        executable = "${pkgs.pavucontrol}/bin/pavucontrol";
        profile = "${pkgs.firejail}/etc/firejail/pavucontrol.profile";
      };
    })
  ]);
}
