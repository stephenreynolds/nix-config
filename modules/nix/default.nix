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
        default = "--delete-older-than 2d";
        description = "Options to pass to the garbage collector";
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

        inherit (cfg) gc;

        # Add each flake input as a registry
        # To make nix3 commands consistent with the flake
        registry = mapAttrs (_: value: { flake = value; }) inputs;

        # Add nixpkgs input to NIX_PATH
        # This lets nix2 commands still use <nixpkgs>
        nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
      };
    }

    (mkIf cfg.lowPriority {
      nix = {
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";
      };
    })
  ];
}
