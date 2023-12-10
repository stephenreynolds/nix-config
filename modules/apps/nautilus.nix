{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.nautilus;
in {
  options.modules.apps.nautilus = {
    enable = lib.mkEnableOption "Whether to install the Nautilus file manager";
  };

  config = lib.mkIf cfg.enable {
    hm.home.packages = with pkgs; [
      gnome.nautilus
      gnome.sushi
      nautilus-open-any-terminal
    ];

    programs.file-roller.enable = true;
  };
}
