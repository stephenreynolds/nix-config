{ config, lib, ... }:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.modules.services.uksmd;

  package = config.nur.repos.xddxdd.uksmd;
in
{
  options.modules.services.uksmd = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the uksmd service";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ package ];

    systemd.packages = [ package ];

    systemd.services.uksmd = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        CPUQuota = "10%";
      };
    };
  };
}
