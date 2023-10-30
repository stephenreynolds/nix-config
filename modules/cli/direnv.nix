{ config, lib, ... }:
with lib;
let cfg = config.flake.cli.direnv;
in {
  options.flake.cli.direnv = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable direnv";
    };
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
