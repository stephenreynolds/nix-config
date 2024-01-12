{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.services.gvfs;
in
{
  options.my.services.gvfs = {
    enable = mkEnableOption "Whether to enable GVfs";
  };

  config = mkIf cfg.enable {
    services.gvfs.enable = true;
  };
}
