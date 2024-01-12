{ config, lib, inputs, ... }:

let
  cfg = config.my.nix;
  hasUser = name: builtins.hasAttr name config.my.users.users;
in
{
  options.my.nix = {
    auto-optimise-store = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to automatically optimise the Nix store";
    };
    gc = {
      automatic = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Automatically run the garbage collector at a specific time";
      };
      dates = lib.mkOption {
        type = lib.types.str;
        default = "weekly";
        description = "How often or when garbage collection is performed";
      };
      options = lib.mkOption {
        type = lib.types.str;
        default = "--delete-older-than +3";
        description = "Options to pass to the garbage collector";
      };
      minFree = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = 100 * 1024 * 1024; # 100 MiB
        description = "Minimum free space to keep in the Nix store";
      };
      maxFree = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = 1024 * 1024 * 1024; # 1 GiB
        description = "Space to free up when the minimum is reached";
      };
    };
    lowPriority = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to set Nix builds to a low priority in order to improve 
        system reponsiveness.
      '';
    };
    use-cgroups = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to execute builds inside cgroups";
    };
  };

  config = lib.mkMerge [
    {
      system.stateVersion = "24.05";

      nix = {
        settings = {
          trusted-users = [ "root" "@wheel" ];
          experimental-features = [
            "auto-allocate-uids"
            "ca-derivations"
            "flakes"
            "nix-command"
            (lib.optionalString cfg.use-cgroups "cgroups")
          ];
          warn-dirty = false;
          inherit (cfg) auto-optimise-store use-cgroups;
        };

        gc = {
          inherit (cfg.gc) automatic dates options;
        };

        extraOptions = lib.concatLines [
          (lib.optionalString (cfg.gc.minFree != null) "min-free = ${toString cfg.gc.minFree}")
          (lib.optionalString (cfg.gc.maxFree != null) "max-free = ${toString cfg.gc.maxFree}")
          "!include ${config.sops.templates."nix-extra-config".path}"
        ];

        # Add each flake input as a registry
        # To make nix3 commands consistent with the flake
        registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

        # Add nixpkgs input to NIX_PATH
        # This lets nix2 commands still use <nixpkgs>
        nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
      };

      hardware.enableRedistributableFirmware = true;
    }

    (lib.mkIf cfg.lowPriority {
      nix = {
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";
      };
    })

    (lib.mkIf (hasUser "stephen") {
      sops.templates."nix-extra-config" = {
        content = "access-tokens = github.com=${config.sops.placeholder.github-access-token}";
        owner = config.users.users.stephen.name;
        mode = "0440";
      };
      sops.secrets.github-access-token = {
        sopsFile = ../../../secrets/stephen.yaml;
        restartUnits = [ "nix-daemon.service" ];
      };
      users.groups.nix-access-tokens = { };
    })
  ];
}
