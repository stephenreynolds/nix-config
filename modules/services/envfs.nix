{ config, lib, ... }:

let cfg = config.modules.services.envfs;
in {
  options.modules.services.envfs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the envfs service";
    };
  };

  config = { services.envfs.enable = cfg.enable; };
}
