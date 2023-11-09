{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.tiling-wm;
in {
  options.modules.desktop.tiling-wm = {
    enable = mkEnableOption ''
      Whether to enable configuration for tiling window managers.
    '';
  };

  config = mkIf cfg.enable (mkMerge [
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
          autotrash = mkDefault {
            enable = true;
            settings = {
              days = 365;
              limit = 100000;
              minFree = null;
            };
          };
          gnome-policykit-agent.enable = mkDefault true;
          playerctl.enable = mkDefault true;
        };
        apps = {
          imv = mkDefault {
            enable = true;
            default = true;
          };
          kitty = mkDefault {
            enable = true;
            default = true;
          };
          mpv.enable = mkDefault true;
          nemo = mkDefault {
            enable = true;
            default = true;
          };
          zathura.enable = true;
        };
      };

      hm.home.packages = with pkgs; [
        gtk3
        xdg-utils
        pulseaudio

        gnome.gnome-calculator
        gnome.gnome-clocks
        pavucontrol
      ];
    }

    (mkIf config.modules.apps.firefox.enable {
      hm.programs.firefox.profiles = (mapAttrs (_: profile: {
        userChrome = ''
          /* Hide the close button */
          .titlebar-buttonbox-container { display:none }
          .titlebar-spacer[type="post-tabs"] { display:none }
        '';
      }) config.modules.apps.firefox.extraProfileConfig);
    })
  ]);
}
