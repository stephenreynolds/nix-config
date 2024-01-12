{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.services.system76-scheduler;
in
{
  options.my.services.system76-scheduler = {
    enable = mkEnableOption "Whether to enable system76-scheduler";
  };

  config = mkIf cfg.enable {
    services.system76-scheduler.enable = true;
  };
}
