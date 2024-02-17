{ config, lib, inputs, ... }:

let
  cfg = config.modules.desktop.hyprland;
in
{
  imports = [ inputs.desktop-flake.nixosModules.default ];

  options.modules.desktop.hyprland = {
    enable = lib.mkEnableOption "Whether to enable Hyprland";
    xdg-autostart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to autostart programs that ask for it";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      modules.desktop.tiling-wm = {
        enable = true;
        wayland = {
          enable = true;
          swww.enable = true;
        };
      };

      desktop-flake.enable = true;
      hm.imports = [ inputs.desktop-flake.homeManagerModules.default ];
      hm.desktop-flake = {
        enable = true;
        xdg-autostart = cfg.xdg-autostart;
      };

      modules.system.persist.cache.home.directories = [ ".cache/ags/user" ];
    }
  ]);
}
