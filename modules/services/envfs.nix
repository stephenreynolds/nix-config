{ config, lib, ... }:
with lib;
let cfg = config.modules.services.envfs;
in {
  options.modules.services.envfs = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the envfs service";
    };
  };

  config = { services.envfs.enable = cfg.enable; };
}
