{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.allusion;
in {
  options.modules.apps.allusion = {
    enable = lib.mkEnableOption "Whether to install Allusion";
  };

  config = lib.mkIf cfg.enable {
    hm.home.packages = [ pkgs.my.allusion ];

    modules.system.persist.state.home.directories = [
      ".config/Allusion"
    ];
  };
}
