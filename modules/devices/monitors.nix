# Source: https://github.com/Misterio77/nix-config/blob/main/modules/home-manager/monitors.nix
{ config, lib, ... }:

let cfg = config.modules.devices.monitors;
in {
  options.modules.devices.monitors = lib.mkOption {
    type = lib.types.listOf (lib.types.submodule {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          example = "DP-1";
        };
        primary = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        width = lib.mkOption {
          type = lib.types.int;
          default = 1920;
        };
        height = lib.mkOption {
          type = lib.types.int;
          default = 1080;
        };
        refreshRate = lib.mkOption {
          type = lib.types.int;
          default = 60;
        };
        x = lib.mkOption {
          type = lib.types.int;
          default = 0;
        };
        y = lib.mkOption {
          type = lib.types.int;
          default = 0;
        };
        enabled = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };
    });
    default = [ ];
  };

  config = {
    assertions = [{
      assertion = ((builtins.length cfg) != 0)
        -> ((builtins.length (builtins.filter (m: m.primary) cfg)) == 1);
      message = "Exactly one monitor must be set to primary.";
    }];
  };
}
