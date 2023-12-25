{ config, lib, ... }:

let cfg = config.my.system.ssd;
in {
  options.my.system.ssd = {
    enable = lib.mkEnableOption "Whether to enable options for SSDs";
  };

  config = lib.mkIf cfg.enable {
    services.fstrim.enable = lib.mkDefault true;
  };
}
