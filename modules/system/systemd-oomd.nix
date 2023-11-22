{ config, lib, ... }:

let cfg = config.modules.system.systemd-oomd;
in {
  options.modules.system.systemd-oomd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable systemd-oomd.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.oomd = {
      enable = true;
      enableUserServices = true;
      enableSystemSlice = true;
      enableRootSlice = true;
      extraConfig = {
        SwapUsedLimitPercent = "90%";
      };
    };

    systemd.extraConfig = ''
      DefaultMemoryAccounting=yes
      DefaultTasksAccounting=yes
    '';
  };
}
