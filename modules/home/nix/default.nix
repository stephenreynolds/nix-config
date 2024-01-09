{ config, lib, pkgs, inputs, ... }:

let cfg = config.modules.nix;
in {
  options.modules.nix = {
    auto-optimise-store = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to automatically optimise the Nix store";
    };
    use-cgroups = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to execute builds inside cgroups";
    };
  };

  config = lib.mkMerge [
    {
      nix = {
        package = pkgs.nix;
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
          inherit (cfg) auto-optimise-store use-cgroups;
        };

        # Add each flake input as a registry
        # To make nix3 commands consistent with the flake
        registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
      };

      nixpkgs.config.allowUnfree = true;
    }
  ];
}
