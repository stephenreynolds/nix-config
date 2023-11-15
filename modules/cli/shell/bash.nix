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

  config = lib.mkIf cfg.enable { hm.programs.bash.enable = true; };
}
