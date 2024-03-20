{ config, lib, outputs, ... }:

let
  inherit (lib)
    mkOption mkEnableOption mapAttrs mkIf mkMerge optional optionalString types;
  cfg = config.modules.services.openssh;
in {
  options.modules.services.openssh = {
    enable = mkEnableOption "Enable openssh service";
    hostKey = {
      enable = mkEnableOption "Whether to authenticate using a host key";
      type = mkOption {
        type = types.enum [ "ed25519" ];
        default = "ed25519";
      };
      privateKey = mkOption {
        type = types.str;
        default = "ssh_host_${cfg.hostKey.type}_key";
      };
      publicKey = mkOption {
        type = types.str;
        default = "${cfg.hostKey.privateKey}.pub";
      };
    };
  };

  config = mkMerge [
    {
      services.openssh = {
        enable = cfg.enable;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          StreamLocalBindUnlink = "yes";
          GatewayPorts = "clientspecified";
        };
      };

      security.pam.sshAgentAuth = {
        enable = true;
        authorizedKeysFiles = [ "/etc/ssh/authorized_keys.d/%u" ];
      };

      modules.system.persist.state.home.directories = [{
        directory = ".ssh";
        mode = "0700";
      }];
    }

    (mkIf cfg.hostKey.enable {
      services.openssh.hostKeys = let
        persistPath = config.modules.system.persist.state.path;
        hasOptinPersistence = config.modules.system.persist.enable;
      in [{
        path = "${
            optionalString hasOptinPersistence persistPath
          }/etc/ssh/${cfg.hostKey.privateKey}";
        type = cfg.hostKey.type;
      }];

      programs.ssh = let
        inherit (config.networking) hostName;
        pubKey = host: ../../hosts/${host}/${cfg.hostKey.publicKey};
        hosts = outputs.nixosConfigurations;
      in {
        knownHosts = mapAttrs (name: _:
          let publicKeyFile = pubKey name;
          in mkIf (builtins.pathExists publicKeyFile) {
            inherit publicKeyFile;
            extraHostNames = optional (name == hostName) "localhost";
          }) hosts;
      };

      modules.system.persist.state.files = [
        "/etc/ssh/${cfg.hostKey.privateKey}"
        "/etc/ssh/${cfg.hostKey.publicKey}"
      ];
    })
  ];
}
