{ config, lib, pkgs, ... }:

let cfg = config.modules.services.openrgb;
in {
  options.modules.services.openrgb = {
    enable = lib.mkEnableOption "Whether to enable OpenRGB service";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.openrgb;
      defaultText = "pkgs.openrgb";
      description = ''
        The package implementing OpenRGB.
      '';
    };
    profile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "The profile to load on startup";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      boot.kernelModules = [ "v4l2loopback" "i2c-dev" "i2c-piix4" ];
      boot.kernelParams = [ "acpi_enforce_resources=lax" ];
      environment.systemPackages = [ cfg.package ];
      services.udev.packages = [ cfg.package ];

      users.groups.i2c = { };
    }

    (lib.mkIf (cfg.profile != null) {
      systemd.services.openrgb = {
        description = "OpenRGB Daemon";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/openrgb --server";
          ExecStartPost =
            "${cfg.package}/bin/openrgb --profile '${cfg.profile}'";
          Restart = "on-failure";
        };
      };
    })
  ]);
}
