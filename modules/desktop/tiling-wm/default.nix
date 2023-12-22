{ config, lib, pkgs, ... }:

let cfg = config.modules.desktop.tiling-wm;
in {
  options.modules.desktop.tiling-wm = {
    enable = lib.mkEnableOption ''
      Whether to enable configuration for tiling window managers.
    '';
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hm.xdg = {
        enable = true;
        mimeApps.enable = true;
        userDirs.enable = true;
        configFile."mimeapps.list".force = true;
      };

      hm.dconf.settings."org/gnome/desktop/wm/preferences".button-layout =
        ":appmenu";

      modules = {
        services = {
          autotrash = lib.mkDefault {
            enable = true;
            settings = {
              days = 365;
              limit = 100000;
              minFree = null;
            };
          };
          gnome-policykit-agent.enable = lib.mkDefault true;
          playerctl.enable = lib.mkDefault true;
          swayidle.enable = lib.mkDefault true;
        };
        apps = {
          imv = lib.mkDefault {
            enable = true;
            default = true;
          };
          kitty = lib.mkDefault {
            enable = true;
            default = true;
          };
          mpv.enable = lib.mkDefault true;
          nemo = lib.mkDefault {
            enable = true;
            default = true;
          };
          sioyek.enable = lib.mkDefault true;
        };
      };

      hm.home.packages = with pkgs; [
        gtk3
        xdg-utils
        pulseaudio

        gnome.gnome-clocks
        qalculate-gtk
        pavucontrol
      ];
    }

    (lib.mkIf config.modules.apps.firefox.enable {
      hm.programs.firefox.profiles = (lib.mapAttrs
        (_: profile: {
          userChrome = ''
            /* Hide the close button */
            .titlebar-buttonbox-container { display:none }
            .titlebar-spacer[type="post-tabs"] { display:none }
          '';
        })
        config.modules.apps.firefox.extraProfileConfig);
    })
  ]);
}
