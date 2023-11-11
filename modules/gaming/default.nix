{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.gaming;
in {
  options.modules.gaming = {
    enable = mkEnableOption "Whether to enable gaming-related fixes and tools";
    memory-fix = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = "Whether to enable memory fix for some games";
      };
    };
    gamemode = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = "Whether to enable GameMode";
      };
    };
    gamescope = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = "Whether to enable Gamescope";
      };
    };
    mangohud = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = "Whether to install MangoHud";
      };
    };
  };

  config = mkMerge [
    {
      modules.system.pipewire.lowLatency = mkDefault true;
    }

    (mkIf cfg.memory-fix.enable {
      boot.kernel.sysctl = { "vm.max_map_count" = 2147483642; };
    })

    (mkIf cfg.gamemode.enable {
      programs.gamemode = {
        enable = true;
        enableRenice = true;
        settings = {
          general = {
            renice = 10;
            softrealtime = "on";
            inhibit_screensaver = 1;
          };
        };
      };
    })

    (mkIf cfg.gamescope.enable {
      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };
    })

    (mkIf cfg.mangohud.enable { hm.home.packages = [ pkgs.mangohud ]; })
  ];
}
