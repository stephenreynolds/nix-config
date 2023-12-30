{ config, lib, ... }:

let cfg = config.my.cli.direnv;
in {
  options.my.cli.direnv = {
    enable = lib.mkEnableOption "Whether to enable direnv";
    log = {
      enable = lib.mkEnableOption "Whether to enable logging";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    }

    (lib.mkIf (!cfg.log.enable) {
      programs.fish.interactiveShellInit = lib.optionalString
        config.my.cli.shell.fish.enable
        "set -x DIRENV_LOG_FORMAT ''";
    })
  ]);
}
