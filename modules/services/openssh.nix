{ config, lib, outputs, ... }:
with lib;
let
  cfg = config.modules.services.openssh;
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;
  pubKey = host: ../../hosts/${host}/ssh_host_ed25519_key.pub;
in {
  options.modules.services.openssh = {
    enable = mkEnableOption "Enable openssh service";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };

    security.pam.enableSSHAgentAuth = true;
  };
}
