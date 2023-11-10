{ config, lib, pkgs, inputs, ... }:
with lib;
let cfg = config.modules.desktop.tiling-wm.wayland;
in {
  options.modules.desktop.tiling-wm.wayland = {
    enable = mkEnableOption ''
      Whether to enable configuration for Wayland compositors
    '';
    ags = { enable = mkEnableOption "Whether to enable ags widgets"; };
    swww = {
      enable = mkEnableOption "Whether to enable swww wallpaper daemon";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.home.packages = with pkgs; [
        qt6.qtwayland
        qt5.qtwayland
        wl-clipboard
        my.primary-xwayland
      ];

      hm.home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        QT_QPA_PLATFORM = "wayland";
        LIBSEAT_BACKEND = "logind";
        #SDL_VIDEODRIVER = "wayland"; # TODO: see if this works now
        GDK_BACKEND = "wayland,x11";
        _JAVA_AWT_WM_NONREPARENTING = 1;
      };
    }

    (mkIf cfg.ags.enable {
      hm.imports = [ inputs.ags.homeManagerModules.default ];

      hm.programs.ags = {
        enable = true;
        configDir = inputs.ags-config.configDir;
      };

      hm.home.packages = with pkgs; [
        inputs.ags.packages.${pkgs.system}.default
        sassc
        inotify-tools
        wf-recorder
        swww
        swappy
        slurp
        imagemagick
        inter
      ];
    })

    (mkIf cfg.swww.enable {
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
          ExecStop = "${getExe pkgs.swww} kill";
          Restart = "on-failure";
        };
      };
    })
  ]);
}