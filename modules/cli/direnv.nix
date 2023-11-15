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
    log = {
      enable = mkEnableOption "Whether to enable logging";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    }

    (mkIf (!cfg.log.enable) {
      hm.programs.fish.interactiveShellInit = optionalString
        config.modules.cli.shell.fish.enable
        "set -x DIRENV_LOG_FORMAT ''";
    })
  ]);
}
