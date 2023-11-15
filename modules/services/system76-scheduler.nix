{ config, lib, ... }:

let cfg = config.modules.services.system76-scheduler;
in {
  options.modules.services.system76-scheduler = {
    enable = lib.mkEnableOption "Whether to enable system76-scheduler";
  };

  config = lib.mkIf cfg.enable {
    services.system76-scheduler.enable = true;
  };
}
