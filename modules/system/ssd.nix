{ config, lib, ... }:
with lib;
let cfg = config.modules.system.ssd;
in {
  options.modules.system.ssd = {
    enable = mkEnableOption "Whether to enable options for SSDs";
  };

  config = mkIf cfg.enable { services.fstrim.enable = mkDefault true; };
}
