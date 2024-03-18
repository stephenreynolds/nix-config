{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.apps.nautilus;
in {
  options.modules.apps.nautilus = {
    enable = mkEnableOption "Whether to install the Nautilus file manager";
    default = mkEnableOption "Whether Nemo should be the default file manager";
  };

  config = mkIf cfg.enable {
    hm.home.packages = with pkgs; [
      gnome.nautilus
      gnome.sushi
      nautilus-open-any-terminal
    ];

    programs.file-roller.enable = true;

    hm.xdg.mimeApps = let nautilus = "org.gnome.Nautilus.desktop";
    in {
      associations.added."inode/directory" = [ nautilus ];
      defaultApplications."inode/directory" = mkIf cfg.default nautilus;
    };

    modules.system.persist.state.home.directories = [ ".local/share/nautilus" ];
  };
}
