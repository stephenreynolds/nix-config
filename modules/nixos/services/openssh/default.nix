{ config, lib, systems, ... }:

let
  cfg = config.my.services.openssh;
  inherit (config.networking) hostName;
  pubKey = system: name: ../../../../systems/${system}/${name}/ssh_host_ed25519_key.pub;
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
        (name: attrs: {
          publicKeyFile = pubKey attrs.system name;
          extraHostNames = lib.optional (name == hostName) "localhost";
        })
        systems;
    };

    security.pam.enableSSHAgentAuth = true;
  };
}
