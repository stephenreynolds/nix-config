{ config, lib, ... }:

let
  cfg = config.my.system.boot;
in
{
  options.my.system.boot = {
    enable = lib.mkEnableOption "Whether or not to enable booting.";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;

    # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
    boot.loader.systemd-boot.editor = false;
  };
}
