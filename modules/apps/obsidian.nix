{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.obsidian;
in {
  options.modules.apps.obsidian = {
    enable = lib.mkEnableOption "Whether to install Obsidian";
  };

  config = lib.mkIf cfg.enable {
    hm.home.packages = [ pkgs.obsidian ];

    modules.system.persist.state.home.directories = [ ".config/obsidian" ];
  };
}
