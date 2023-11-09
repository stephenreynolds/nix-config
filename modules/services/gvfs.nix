{ config, lib, ... }:
with lib;
let cfg = config.modules.services.gvfs;
in {
  options.modules.services.gvfs = {
    enable = mkEnableOption "Whether to enable GVfs";
  };

  config = mkIf cfg.enable {
    services.gvfs.enable = true;
  };
}
