{ config, lib, ... }:
with lib;
let cfg = config.modules.cli.shell.bash;
in {
  options.modules.cli.shell.bash = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable bash";
    };
  };

  config = mkIf cfg.enable { hm.programs.bash.enable = true; };
}
