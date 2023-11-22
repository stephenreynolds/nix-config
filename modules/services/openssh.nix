{ config, lib, outputs, pkgs, ... }:

let
  cfg = config.modules.services.openssh;
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;
  pubKey = host: ../../hosts/${host}/ssh_host_ed25519_key.pub;
in
{
  options.modules.services.openssh = {
    enable = lib.mkEnableOption "Enable openssh service";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
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
            extraHostNames = (lib.optional (name == hostName) "localhost");
          })
          hosts;
      };

      security.pam.enableSSHAgentAuth = true;
    }

    (lib.mkIf config.modules.system.security.firejail.enable {
      programs.firejail.wrappedBinaries = {
        ssh = {
          executable = "${pkgs.openssh}/bin/ssh";
          profile = "${pkgs.firejail}/etc/firejail/ssh.profile";
        };
        ssh-agent = {
          executable = "${pkgs.openssh}/bin/ssh-agent";
          profile = "${pkgs.firejail}/etc/firejail/ssh-agent.profile";
        };
      };
    })
  ]);
}
