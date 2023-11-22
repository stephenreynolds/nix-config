{ config, lib, ... }:

let cfg = config.modules.system.security.firejail;
in {
  options.modules.system.security.firejail = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable firejail";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firejail.enable = true;
  };
}
