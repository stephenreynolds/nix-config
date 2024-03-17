{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.nautilus;
in {
  options.modules.apps.nautilus = {
    enable = lib.mkEnableOption "Whether to install the Nautilus file manager";
    default =
      lib.mkEnableOption "Whether Nemo should be the default file manager";
  };

  config = lib.mkIf cfg.enable {
    hm.home.packages = with pkgs; [
      gnome.nautilus
      gnome.sushi
      nautilus-open-any-terminal
    ];

    programs.file-roller.enable = true;

    hm.xdg.mimeApps.defaultApplications."inode/directory" =
      lib.optionalString cfg.default "nautilus.desktop";

    modules.system.persist.state.home.directories = [ ".local/share/nautilus" ];
  };
}
