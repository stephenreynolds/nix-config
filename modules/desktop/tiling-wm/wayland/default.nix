{ config, lib, pkgs, ... }:

let cfg = config.modules.desktop.tiling-wm.wayland;
in {
  options.modules.desktop.tiling-wm.wayland = {
    enable = lib.mkEnableOption ''
      Whether to enable configuration for Wayland compositors
    '';
    swww = {
      enable = lib.mkEnableOption "Whether to enable swww wallpaper daemon";
    };
    sessionVariables = lib.mkOption {
      type = with lib.types; lazyAttrsOf (oneOf [ str path int float ]);
      default = {
        MOZ_ENABLE_WAYLAND = 1;
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        GDK_BACKEND = "wayland,x11";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = 1;
        NIXOS_OZONE_WL = 1;
        LIBSEAT_BACKEND = "logind";
      };
      description = "Environment variables to set in all Wayland sessions";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hm.home.packages = with pkgs; [
        qt6.qtwayland
        qt5.qtwayland
        wl-clipboard
        my.primary-xwayland
      ];

      modules.desktop.tiling-wm.wayland.swaylock.enable = true;
    }

    (lib.mkIf cfg.swww.enable {
      hm.systemd.user.services.swww = {
        Unit = {
          Description = "Wayland wallpaper daemon";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.swww}/bin/swww-daemon";
          ExecStop = "${lib.getExe pkgs.swww} kill";
          Restart = "on-failure";
        };
      };
    })
  ]);
}
