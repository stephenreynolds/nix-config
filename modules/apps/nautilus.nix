{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.modules.apps.nautilus;
in
{
  options.modules.apps.nautilus = {
    enable = mkEnableOption "Whether to install the Nautilus file manager";
    default = mkEnableOption "Whether Nemo should be the default file manager";
    bookmarks = mkOption {
      type = types.str;
      default = "";
      description = "Directory bookmarks";
    };
  };

  config = mkIf cfg.enable {
    hm.home.packages = with pkgs; [
      gnome.nautilus
      gnome.sushi
      nautilus-open-any-terminal
    ];

    programs.file-roller.enable = true;

    hm.xdg.mimeApps =
      let nautilus = "org.gnome.Nautilus.desktop";
      in {
        associations.added."inode/directory" = [ nautilus ];
        defaultApplications."inode/directory" = mkIf cfg.default nautilus;
      };

    hm.xdg.configFile."gtk-3.0/bookmarks".text = cfg.bookmarks;

    modules.system.persist.state.home.directories = [
      ".local/share/nautilus"
    ];
  };
}
