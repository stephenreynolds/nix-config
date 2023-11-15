{ config, lib, ... }:

let cfg = config.modules.system.ssd;
in {
  options.modules.system.ssd = {
    enable = lib.mkEnableOption "Whether to enable options for SSDs";
  };

  config = lib.mkIf cfg.enable { services.fstrim.enable = lib.mkDefault true; };
}
