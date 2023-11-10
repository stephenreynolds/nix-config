{ config, lib, inputs, pkgs, ... }:
with lib;
let
  cfg = config.modules.nix.auto-upgrade;
  isClean = inputs.self ? rev;
in
{
  options.modules.nix.auto-upgrade = {
    enable = mkEnableOption "Whether to automatically upgrade NixOS";
    dates = mkOption {
      type = types.str;
      default = "daily";
      description = "How often to check for updates";
    };
  };

  config = mkIf cfg.enable {
    system.autoUpgrade = {
      enable = isClean;
      dates = cfg.dates;
      flags = [ "--refresh" ];
      flake = "github:stephenreynolds/nix-config";
    };

    systemd.services.nixos-upgrade = mkIf config.system.autoUpgrade.enable {
      serviceConfig.ExecCondition = getExe
        (pkgs.writeShellScriptBin "check-date" ''
          lastModified() {
            nix flake metadata "$1" --refresh --json | ${
              getExe pkgs.jq
            } '.lastModified'
            test "$(lastModified "${config.system.autoUpgrade.flake}")" -gt "$(lastModified "self")"
          }
        '');
    };
  };
}
