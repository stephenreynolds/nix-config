{ config, lib, inputs, ... }:
with lib;
let cfg = config.modules.nix;
in {
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
        default = "--delete-older-than +3";
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
    lowPriority = mkEnableOption ''
      Whether to set Nix builds to a low priority in order to improve 
      system reponsiveness.
    '';
  };

  config = mkMerge [
    {
      nix = {
        settings = {
          trusted-users = [ "root" "@wheel" ];
          experimental-features = [ "nix-command flakes repl-flake" ];
          warn-dirty = false;
          inherit (cfg) auto-optimise-store;
        };

        gc = {
          inherit (cfg.gc) automatic dates options;
        };

        extraOptions = concatLines [
          (optionalString (cfg.gc.minFree != null) "min-free = ${toString cfg.gc.minFree}")
          (optionalString (cfg.gc.maxFree != null) "max-free = ${toString cfg.gc.maxFree}")
        ];

        # Add each flake input as a registry
        # To make nix3 commands consistent with the flake
        registry = mapAttrs (_: value: { flake = value; }) inputs;

        # Add nixpkgs input to NIX_PATH
        # This lets nix2 commands still use <nixpkgs>
        nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
      };

      hardware.enableRedistributableFirmware = true;
    }

    (mkIf cfg.lowPriority {
      nix = {
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";
      };
    })
  ];
}
