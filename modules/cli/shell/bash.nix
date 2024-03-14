{ config, lib, ... }:

let cfg = config.modules.cli.shell.bash;
in {
  options.modules.cli.shell.bash = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable bash";
    };
  };

  config = lib.mkIf cfg.enable {
    hm.programs.bash.enable = true;

    hm.home.sessionVariables.HISTFILE =
      "${config.hm.xdg.stateHome}/bash/history";

    modules.system.persist.state.home.directories = [ ".local/state/bash" ];
  };
}
