{ config, lib, options, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkMerge mkAliasDefinitions types;
  cfg = config.modules.users;
in {
  options.user = mkOption {
    type = types.attrs;
    default = { };
  };

  options.modules.users = {
    users = {
      stephen = { enable = mkEnableOption "Enable Stephen's user account"; };
      generic = {
        enable = mkEnableOption "Enable Stephen's user account";
        name = mkOption {
          type = types.str;
          default = "nixos";
        };
        initialPassword = mkOption {
          type = types.str;
          default = "nixos";
        };
        shell = mkOption {
          type = types.package;
          default = pkgs.bash;
        };
      };
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
        ifTheyExist = groups:
          builtins.filter (group: builtins.hasAttr group config.users.groups)
          groups;
      in {
        isNormalUser = true;
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

      users.users.${config.user.name} = mkAliasDefinitions options.user;

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

    (mkIf cfg.users.stephen.enable {
      user = {
        name = "stephen";
        shell = pkgs.fish;
      };

      users.users.stephen.hashedPasswordFile =
        config.sops.secrets.stephen-password.path;

      sops.secrets.stephen-password = {
        sopsFile = ../sops/secrets.yaml;
        neededForUsers = true;
      };
    })

    (mkIf cfg.users.generic.enable {
      user = {
        inherit (cfg.users.generic) name initialPassword;
        isNormalUser = true;
        shell = cfg.users.generic.shell;
        extraGroups = [ "wheel" ];
      };
    })
  ];
}
