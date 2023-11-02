{ config, lib, ...}:
with lib;
let cfg = config.modules.services.system76-scheduler;
in {
  options.modules.services.system76-scheduler = {
    enable = mkEnableOption "Whether to enable system76-scheduler";
  };

  config = mkIf cfg.enable {
    services.system76-scheduler.enable = true;
  };
}
