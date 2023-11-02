# NOTE: Follow the following article to configure secure boot:
# https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md

{ config, lib, pkgs, inputs, ... }:
with lib;
let cfg = config.modules.system.secure-boot;
in {
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  options.modules.system.secure-boot = {
    enable = mkEnableOption "Whether to enable support for secure boot";
    sbctl = {
      enable = mkEnableOption ''
        Whether to install sbctl for debugging and troubleshooting secure boot
      '';
    };
  };

  # TODO: See if it possible to provide the keys declaratively instead of 
  # using sbctl to create and enroll them.
  config = mkIf cfg.enable {
    environment.systemPackages = mkIf cfg.sbctl.enable [ pkgs.sbctl ];

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}
