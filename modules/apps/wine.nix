{ config, lib, pkgs, ... }:

let cfg = config.modules.apps.wine;
in {
  options.modules.apps.wine = {
    enable = lib.mkEnableOption "Whether to enable Wine";
    waylandSupport = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.desktop.tiling-wm.wayland.enable;
      description = "Whether to enable Wayland support";
    };
    winetricks.enable = lib.mkEnableOption "Whether to install Winetricks";
    bottles.enable = lib.mkEnableOption "Whether to install bottles";
  };

  config = lib.mkIf cfg.enable {
    hm.home.packages = with pkgs; [
      (if cfg.waylandSupport then
        wineWowPackages.waylandFull
      else
        wineWowPackages.full)

      (lib.mkIf cfg.winetricks.enable winetricks)

      (lib.mkIf cfg.bottles.enable bottles)
    ];

    modules.system.pipewire.support32Bit = lib.mkForce true;
    modules.system.nvidia.support32Bit = lib.mkForce true;

    environment.sessionVariables = { WINEDEBUG = "-all"; };

    modules.system.persist.state.home.directories = [
      ".local/share/bottles"
    ];
  };
}
