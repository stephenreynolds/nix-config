{ config, lib, inputs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types optionalString attrValues concatLines;
  cfg = config.modules.system.persist;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.modules.system.persist =
    let
      common = {
        directories = mkOption {
          type = with types; listOf (either str attrs);
          default = [ ];
          description = "Directories to persist";
        };
        files = mkOption {
          type = with types; listOf (either str attrs);
          default = [ ];
          description = "Files to persist";
        };
      };
    in
    {
      enable = mkEnableOption "Whether to enable opt-in persistence";
      state = {
        path = mkOption {
          type = types.str;
          default = "/persist";
          description = "The path where files are persisted to";
        };
        home = common;
      } // common;
      cache = {
        path = mkOption {
          type = types.str;
          default = "/cache";
          description = "The path where cache files are persisted to";
        };
        clean = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to periodically clear cached files";
          };
          dates = mkOption {
            type = types.str;
            default = "weekly";
            description = "A systemd.timer calendar description of when to clear the cache";
          };
        };
        home = common;
      } // common;
    };

  config = mkIf cfg.enable {
    environment.persistence = {
      "${cfg.state.path}" = {
        hideMounts = true;
        directories = [
          "/etc/machine-id"
          "/var/lib/systemd"
          "/var/lib/nixos"
          "/var/log"
        ] ++ cfg.state.directories;
        files = cfg.state.files;
        users.${config.user.name} = {
          directories = cfg.state.home.directories;
          files = cfg.state.home.files;
        };
      };
      "${cfg.cache.path}" = {
        hideMounts = true;
        directories = [
          "/var/cache"
        ] ++ cfg.cache.directories;
        files = cfg.cache.directories;
        users.${config.user.name} = {
          directories = [
            ".cache"
          ] ++ cfg.cache.home.directories;
          files = cfg.cache.home.files;
        };
      };
    };

    programs.fuse.userAllowOther = true;

    system.activationScripts.persistent-dirs.text =
      let
        mkHomePersist = user: optionalString user.createHome ''
          mkdir -p ${cfg.state.path}/${user.home}
          chown ${user.name}:${user.group} ${cfg.state.path}/${user.home}
          chmod ${user.homeMode} ${cfg.state.path}/${user.home}

          mkdir -p ${cfg.cache.path}/${user.home}
          chown ${user.name}:${user.group} ${cfg.cache.path}/${user.home}
          chmod ${user.homeMode} ${cfg.cache.path}/${user.home}
        '';
        users = attrValues config.users.users;
      in
      concatLines (map mkHomePersist users);

    systemd.services.persist-cache-cleanup = mkIf cfg.cache.clean.enable {
      description = "Cleaning up cache files and directories";
      script =
        let
          inherit (lib) escapeShellArg;
          inherit (builtins) concatStringsSep;
          absoluteHomeFiles = map (x: "${config.hm.home.homeDirectory}/${x}");
        in
        ''
          ${concatStringsSep "\n" (map (x: "rm ${escapeShellArg x}")
            (cfg.cache.files ++ absoluteHomeFiles cfg.cache.home.files))}

          ${concatStringsSep "\n" (map (x: "rm -rf ${escapeShellArg x}")
            (cfg.cache.directories ++ absoluteHomeFiles cfg.cache.home.directories))}
        '';
      startAt = cfg.cache.clean.dates;
    };
  };
}
