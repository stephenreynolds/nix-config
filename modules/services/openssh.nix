{ config, lib, outputs, ... }:

let
  inherit (lib) mkEnableOption mapAttrs optional optionalString;
  cfg = config.modules.services.openssh;
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;
  pubKey = host: ../../hosts/${host}/ssh_host_ed25519_key.pub;

  persistPath = config.modules.system.persist.state.path;
  hasOptinPersistence = config.modules.system.persist.enable;
in
{
  options.modules.services.openssh = {
    enable = mkEnableOption "Enable openssh service";
  };

  config = {
    services.openssh = {
      enable = cfg.enable;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        GatewayPorts = "clientspecified";
      };
      hostKeys = [{
        path = "${optionalString hasOptinPersistence persistPath}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }];
    };

    programs.ssh = {
      knownHosts = mapAttrs
        (name: _: {
          publicKeyFile = pubKey name;
          extraHostNames = (optional (name == hostName) "localhost");
        })
        hosts;
    };

    security.pam.sshAgentAuth = {
      enable = true;
      authorizedKeysFiles = [ "/etc/ssh/authorized_keys.d/%u" ];
    };

    modules.system.persist.state.files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
    modules.system.persist.state.home.directories = [
      { directory = ".ssh"; mode = "0700"; }
    ];
  };
}
