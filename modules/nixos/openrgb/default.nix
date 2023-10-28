# Source: https://github.com/Misterio77/nix-config/blob/main/modules/nixos/openrgb.nix
{ config, lib, pkgs, ... }:

with lib;

let cfg = config.hardware.openrgb;

in {
  options.hardware.openrgb = {
    enable = mkEnableOption "OpenRGB";
    package = mkOption {
      type = types.package;
      default = pkgs.openrgb;
      defaultText = "pkgs.openrgb";
      description = ''
        The package implementing OpenRGB.
      '';
    };
  };
  config = mkIf cfg.enable {
    boot.kernelModules = [ "v4l2loopback" "i2c-dev" "i2c-piix4" ];
    boot.kernelParams = [ "acpi_enforce_resources=lax" ];
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    systemd.services.openrgb = {
      description = "OpenRGB Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/openrgb --server";
        ExecStartPost = "${cfg.package}/bin/openrgb --profile '${./off.orp}'";
        Restart = "on-failure";
      };
    };
  };
}
