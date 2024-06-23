{ config, lib, ... }:

let cfg = config.modules.cli.direnv;
in {
  options.modules.cli.direnv = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable direnv";
    };
    log = { enable = lib.mkEnableOption "Whether to enable logging"; };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hm.programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      modules.system.persist.state.home.directories = [ ".local/share/direnv" ];
    }

    (lib.mkIf (!cfg.log.enable) {
      hm.programs.fish.interactiveShellInit =
        lib.optionalString config.modules.cli.shell.fish.enable
          "set -x DIRENV_LOG_FORMAT ''";
    })
  ]);
}
