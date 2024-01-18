{ config, lib, options, pkgs, ... }:

let cfg = config.modules.users;
in
{
  options.user = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };

  options.modules.users = {
    users = {
      stephen = { enable = lib.mkEnableOption "Enable Stephen's user account"; };
    };

    mutableUsers = lib.mkEnableOption ''
      Allow adding new users and groups using `useradd` and `groupadd` commands.
      If set to false, users and groups will be replaced on system activation.
    '';
  };

  config = lib.mkMerge [
    {
      users.mutableUsers = cfg.mutableUsers;

      user =
        let
          user = builtins.getEnv "USER";
          name = if builtins.elem user [ "" "root" ] then "stephen" else user;
          ifTheyExist = groups:
            builtins.filter (group: builtins.hasAttr group config.users.groups)
              groups;
        in
        {
          inherit name;
          isNormalUser = true;
          shell = pkgs.fish;
          extraGroups = [ "wheel" "input" "audio" "video" "storage" ]
            ++ ifTheyExist [
            "i2c"
            "docker"
            "podman"
            "git"
            "libvirtd"
            "mlocate"
            "flatpak"
            "tss"
            "libvirtd"
            "gamemode"
            "nix-access-tokens"
            "openai-api-key"
          ];
        };

      users.users.${config.user.name} = lib.mkAliasDefinitions options.user;

      security.pam.loginLimits = [
        {
          domain = "@wheel";
          item = "nofile";
          type = "soft";
          value = "524288";
        }
        {
          domain = "@wheel";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
      ];
    }

    (lib.mkIf cfg.users.stephen.enable {
      users.users.stephen.hashedPasswordFile =
        config.sops.secrets.stephen-password.path;

      sops.secrets.stephen-password = {
        sopsFile = ../sops/secrets.yaml;
        neededForUsers = true;
      };
    })
  ];
}
