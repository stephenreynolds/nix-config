{ config, lib, ... }:
with lib;
let cfg = config.modules.shell.bash;
in {
  options.modules.shell.bash = {
    enable = mkEnableOption "Whether to enable bash";
  };

  config = mkIf cfg.enable { hm.programs.bash.enable = true; };
}
