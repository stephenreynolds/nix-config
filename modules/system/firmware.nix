{ config, lib, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.modules.system.firmware;
in {
  options.modules.system.firmware = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to allow applications to update firmwar";
    };
  };

  config = { services.fwupd.enable = cfg.enable; };
}
