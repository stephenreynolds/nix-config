{ config, lib, outputs, ... }:

let
  cfg = config.my.services.openssh;
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;
  pubKey = host: ../../../hosts/${host}/ssh_host_ed25519_key.pub;
in
{
  options.my.services.openssh = {
    enable = lib.mkEnableOption "Enable openssh service";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        GatewayPorts = "clientspecified";
      };
      hostKeys = [{
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }];
    };

    programs.ssh = {
      knownHosts = lib.mapAttrs
        (name: _: {
          publicKeyFile = pubKey name;
          extraHostNames = lib.optional (name == hostName) "localhost";
        })
        hosts;
    };

    security.pam.enableSSHAgentAuth = true;
  };
}
