{ config, lib, inputs, pkgs, ... }:

let
  cfg = config.my.nix.auto-upgrade;
  isClean = inputs.self ? rev;
in
{
  options.my.nix.auto-upgrade = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to automatically upgrade NixOS";
    };
    dates = lib.mkOption {
      type = lib.types.str;
      default = "daily";
      description = "How often to check for updates";
    };
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = isClean;
      dates = cfg.dates;
      flags = [ "--refresh" ];
      flake = "github:stephenreynolds/nix-config";
    };

    systemd.services.nixos-upgrade = lib.mkIf config.system.autoUpgrade.enable {
      serviceConfig.ExecCondition = lib.getExe
        (pkgs.writeShellScriptBin "check-date" ''
          lastModified() {
            nix flake metadata "$1" --refresh --json | ${lib.getExe pkgs.jq} '.lastModified'
          }
          test "$(lastModified "${config.system.autoUpgrade.flake}")" -gt "$(lastModified "self")"
        '');
    };
  };
}
