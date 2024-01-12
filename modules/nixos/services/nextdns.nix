{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.my.services.nextdns;
  hasUser = name: builtins.hasAttr name config.my.users.users;
in
{
  options.my.services.nextdns = {
    enable = mkEnableOption "Enable NextDNS";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.nextdns.enable = true;
    }

    (mkIf (hasUser "stephen") {
      services.nextdns.arguments = [
        "-config-file"
        "${config.sops.templates."nextdns.conf".path}"
      ];

      sops.templates."nextdns.conf" = {
        content = ''
          profile ${config.sops.placeholder.nextdns-id}
          cache-size 10MB
          auto-activate yes
        '';
      };

      sops.secrets.nextdns-id = {
        restartUnits = [ "nextdns.service" ];
        sopsFile = .../../../secrets/stephen.yaml;
      };
    })
  ]);
}
