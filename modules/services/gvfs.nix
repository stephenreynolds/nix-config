{ config, lib, ... }:

let cfg = config.modules.services.gvfs;
in {
  options.modules.services.gvfs = {
    enable = lib.mkEnableOption "Whether to enable GVfs";
  };

  config = lib.mkIf cfg.enable {
    services.gvfs.enable = true;
  };
}
