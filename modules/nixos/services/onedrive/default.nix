{ config, lib, ... }:

let cfg = config.my.services.onedrive;
in
{
  options.my.services.onedrive = {
    enable = lib.mkEnableOption "Whether to enable the OneDrive service";
    logging = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable logging";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      services.onedrive.enable = true;
    }

    (lib.mkIf cfg.logging.enable {
      systemd.tmpfiles.rules = [ "d /var/log/onedrive 0775 root users" ];
    })
  ]);
}
