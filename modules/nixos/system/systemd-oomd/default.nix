{ config, lib, ... }:

let cfg = config.my.system.systemd-oomd;
in {
  options.my.system.systemd-oomd = {
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
    };

    systemd.extraConfig = ''
      DefaultMemoryAccounting=yes
      DefaultTasksAccounting=yes
    '';
  };
}
