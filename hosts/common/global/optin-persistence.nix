{ lib, inputs, config, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence = {
    "/persist" = {
      directories = [
        "/var/log"
        "/etc/passwords"
      ];
    };
  };

  programs.fuse.userAllowOther = true;

  system.activationScripts.persistent-dirs =
    let
      mkHomePersist = user: lib.optionalString user.createHome ''
        mkdir -p /persist/${user.home}
        chown ${user.name}:${user.group} /persist/${user.home}
        chmod ${user.homeMode} /persist/${user.home}
      '';
      users = lib.attrValues config.users.users;
    in
    lib.concatLines (map mkHomePersist users);
}
