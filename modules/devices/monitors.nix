# Source: https://github.com/Misterio77/nix-config/blob/main/modules/home-manager/monitors.nix
{ config, lib, ... }:
with lib;
let cfg = config.modules.devices.monitors;
in {
  options.modules.devices.monitors = mkOption {
    type = types.listOf (types.submodule {
      options = {
        name = mkOption {
          type = types.str;
          example = "DP-1";
        };
        primary = mkOption {
          type = types.bool;
          default = false;
        };
        width = mkOption {
          type = types.int;
          default = 1920;
        };
        height = mkOption {
          type = types.int;
          default = 1080;
        };
        refreshRate = mkOption {
          type = types.int;
          default = 60;
        };
        x = mkOption {
          type = types.int;
          default = 0;
        };
        y = mkOption {
          type = types.int;
          default = 0;
        };
        enabled = mkOption {
          type = types.bool;
          default = true;
        };
      };
    });
    default = [ ];
  };

  config = {
    assertions = [{
      assertion = ((length cfg) != 0)
        -> ((length (filter (m: m.primary) cfg)) == 1);
      message = "Exactly one monitor must be set to primary.";
    }];
  };
}
