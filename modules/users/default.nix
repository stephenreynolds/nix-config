{ config, lib, options, ... }:
with lib;
let cfg = config.modules.users;
in {
  options.user = mkOption {
    type = types.attrs;
    default = { };
  };

  options.modules.users = {
    users = {
      stephen = { enable = mkEnableOption "Enable Stephen's user account"; };
    };

    mutableUsers = mkEnableOption ''
      Allow adding new users and groups using `useradd` and `groupadd` commands.
      If set to false, users and groups will be replaced on system activation.
    '';
  };

  config = mkMerge [
    {
      users.mutableUsers = cfg.mutableUsers;

      user = let
        user = builtins.getEnv "USER";
        name = if elem user [ "" "root" ] then "stephen" else user;
      in {
        inherit name;
        isNormalUser = true;
        extraGroups = [ "wheel" "input" "audio" "video" "storage" ];
      };

      users.users.${config.user.name} = mkAliasDefinitions options.user;
    }

    (mkIf cfg.users.stephen.enable {
      users.users.stephen.hashedPasswordFile =
        config.sops.secrets.stephen-password.path;

      sops.secrets.stephen-password = {
        sopsFile = ../sops/secrets.yaml;
        neededForUsers = true;
      };
    })
  ];
}
