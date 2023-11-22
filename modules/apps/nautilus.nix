{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.nautilus;
in {
  options.modules.apps.nautilus = {
    enable = lib.mkEnableOption "Whether to install the Nautilus file manager";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hm.home.packages = with pkgs; [
        gnome.nautilus
        gnome.sushi
        nautilus-open-any-terminal
      ];

      programs.file-roller.enable = true;
    }

    (lib.mkIf config.modules.system.security.firejail.enable {
      programs.firejail.wrappedBinaries = {
        file-roller = {
          executable = "${config.programs.file-roller.package}/bin/file-roller";
          profile = "${pkgs.firejail}/etc/firejail/file-roller.profile";
        };
        nautilus = {
          executable = "${pkgs.gnome.nautilus}/bin/nautilus";
          profile = "${pkgs.firejail}/etc/firejail/nautilus.profile";
        };
        sushi = {
          executable = "${pkgs.gnome.sushi}/bin/sushi";
          profile = "${pkgs.firejail}/etc/firejail/sushi.profile";
        };
      };
    })
  ]);
}
