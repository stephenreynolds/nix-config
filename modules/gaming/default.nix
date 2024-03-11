{ config, lib, pkgs, ... }:

let cfg = config.modules.gaming;
in {
  options.modules.gaming = {
    enable = lib.mkEnableOption "Whether to enable gaming-related fixes and tools";
    memory-fix = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Whether to enable memory fix for some games";
      };
    };
    gamemode = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable && !config.modules.services.system76-scheduler.enable;
        description = "Whether to enable GameMode";
      };
    };
    gamescope = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Whether to enable Gamescope";
      };
    };
    mangohud = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Whether to install MangoHud";
      };
    };
  };

  config = lib.mkMerge [
    {
      modules.system.pipewire.lowLatency = lib.mkDefault true;

      systemd.extraConfig = "DefaultLimitNOFILE=1048576";

      environment.sessionVariables = { WINEDEBUG = "-all"; };
    }

    (lib.mkIf cfg.memory-fix.enable {
      boot.kernel.sysctl = {
        "vm.max_map_count" = 2147483642;
        "kernel.split_lock_mitigate" = 0;
      };
    })

    (lib.mkIf cfg.gamemode.enable {
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

      users.groups.gamemode = { };
    })

    (lib.mkIf cfg.gamescope.enable {
      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };
    })

    (lib.mkIf cfg.mangohud.enable { hm.home.packages = [ pkgs.mangohud ]; })
  ];
}
