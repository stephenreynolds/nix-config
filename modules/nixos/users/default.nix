{ config, lib, pkgs, ... }:

let
  cfg = config.my.users;

  mapUsers = fn: lib.mapAttrs fn cfg.users;
  hasUser = name: builtins.hasAttr name cfg.users;
in
{
  options.my.users = {
    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = name;
            description = "The username.";
          };
          isNormalUser = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether the user is a real user.";
          };
          initialPassword = lib.mkOption {
            type = lib.types.str;
            default = "password";
            description = "The initial password to use when the user is first created.";
          };
          shell = lib.mkOption {
            type = lib.types.package;
            default = pkgs.shadow;
            description = "The shell to use for the user.";
          };
          extraGroups = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Extra groups to add the user to.";
          };
        };
      }));
      default = { };
      description = "The users to create.";
    };
    mutableUsers = lib.mkEnableOption ''
      Allow adding new users and groups using `useradd` and `groupadd` commands.
       If set to false, users and groups will be replaced on system activation.
    '';
  };

  config = lib.mkMerge [
    {
      users = {
        mutableUsers = cfg.mutableUsers;
      };

      users.users = mapUsers (_: user: lib.mkMerge [
        {
          inherit (user) name isNormalUser initialPassword shell extraGroups;
        }
      ]);

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

    (lib.mkIf (hasUser "stephen") {
      # users.users.stephen.hashedPasswordFile = config.sops.secrets.stephen-password.path;

      sops.secrets.stephen-password = {
        sopsFile = ../../../secrets/stephen.yaml;
        neededForUsers = true;
      };
    })
  ];
}
