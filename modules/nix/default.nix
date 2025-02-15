{ config, lib, inputs, ... }:

let
  inherit (lib) mkOption mkMerge mkIf concatLines mapAttrs optionalString types;
  cfg = config.modules.nix;
in
{
  options.modules.nix = {
    auto-optimise-store = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to automatically optimise the Nix store";
    };
    gc = {
      automatic = mkOption {
        type = types.bool;
        default = true;
        description =
          "Automatically run the garbage collector at a specific time";
      };
      dates = mkOption {
        type = types.str;
        default = "weekly";
        description = "How often or when garbage collection is performed";
      };
      options = mkOption {
        type = types.str;
        default = "--delete-older-than 30d";
        description = "Options to pass to the garbage collector";
      };
      minFree = mkOption {
        type = types.nullOr types.int;
        default = 100 * 1024 * 1024; # 100 MiB
        description = "Minimum free space to keep in the Nix store";
      };
      maxFree = mkOption {
        type = types.nullOr types.int;
        default = 1024 * 1024 * 1024; # 1 GiB
        description = "Space to free up when the minimum is reached";
      };
    };
    lowPriority = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to set Nix builds to a low priority in order to improve
        system reponsiveness.
      '';
    };
    use-cgroups = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to execute builds inside cgroups";
    };
  };

  config = mkMerge [
    {
      nix = {
        settings = {
          trusted-users = [ "root" "@wheel" ];
          experimental-features = [
            "auto-allocate-uids"
            "ca-derivations"
            "cgroups"
            "flakes"
            "nix-command"
          ];
          warn-dirty = false;
          fallback = true;
          inherit (cfg) auto-optimise-store use-cgroups;
        };

        gc = { inherit (cfg.gc) automatic dates options; };

        extraOptions = concatLines [
          (optionalString (cfg.gc.minFree != null)
            "min-free = ${toString cfg.gc.minFree}")
          (optionalString (cfg.gc.maxFree != null)
            "max-free = ${toString cfg.gc.maxFree}")
          "!include ${config.sops.templates."nix-extra-config".path}"
        ];

        # Add each flake input as a registry
        # To make nix3 commands consistent with the flake
        registry = mapAttrs (_: value: { flake = value; }) inputs;

        # Add nixpkgs input to NIX_PATH
        # This lets nix2 commands still use <nixpkgs>
        nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
      };

      environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
      hm.nixpkgs.config.allowUnfree = true;

      hardware.enableRedistributableFirmware = true;

      sops.templates."nix-extra-config" = {
        content =
          "access-tokens = github.com=${config.sops.placeholder.github-access-token}";
        group = config.users.groups.nix-access-tokens.name;
        mode = "0440";
      };
      sops.secrets.github-access-token = {
        sopsFile = ../sops/secrets.yaml;
        restartUnits = [ "nix-daemon.service" ];
      };
      users.groups.nix-access-tokens = { };

      modules.system.persist.state.home.directories = [ ".local/share/nix" ];
    }

    (mkIf cfg.lowPriority {
      nix = {
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";
      };
    })

    (mkIf config.modules.cli.direnv.enable {
      nix.settings = {
        keep-outputs = true;
        keep-derivations = true;
      };
    })
  ];
}
