{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.services.nextdns;
in
{
  options.modules.services.nextdns = {
    enable = mkEnableOption "Enable NextDNS";
  };

  config = mkIf cfg.enable {
    services.nextdns = {
      enable = true;
      arguments = [ "-config-file" "${config.sops.templates."nextdns.conf".path}" ];
    };

    sops.templates."nextdns.conf" = {
      content = ''
        profile ${config.sops.placeholder.nextdns-id}
        cache-size 10MB
        auto-activate yes
      '';
    };

    sops.secrets.nextdns-id = {
      restartUnits = [ "nextdns.service" ];
      sopsFile = ../sops/secrets.yaml;
    };
  };
}
