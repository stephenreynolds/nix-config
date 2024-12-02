{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge mkDefault types;
  cfg = config.modules.services.tailscale;
in
{
  options.modules.services.tailscale = {
    enable = mkEnableOption "Whether to enable Tailscale";
    authKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "A file containing the auth key. Tailscale will be automatically started if provided.";
    };
  };

  config = mkIf cfg.enable
    (mkMerge [
      {
        services.tailscale = {
          enable = true;
          authKeyFile = mkDefault cfg.authKeyFile;
        };
      }

      (mkIf config.modules.users.users.stephen.enable {
        sops.secrets.tailscale-auth-key = {
          sopsFile = ../sops/secrets.yaml;
        };

        services.tailscale.authKeyFile = config.sops.secrets.tailscale-auth-key.path;
      })
    ]);
}
