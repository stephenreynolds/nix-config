{ inputs, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets.stephen-password = {
      sopsFile = ./secrets/secrets.yaml;
      neededForUsers = true;
    };
  };
}
