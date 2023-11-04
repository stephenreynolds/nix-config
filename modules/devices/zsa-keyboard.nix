{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.devices.zsa-keyboard;
in {
  options.modules.devices.zsa-keyboard = {
    enable = mkEnableOption "Whether to enable udev rules for ZSA keyboards";
    wally-cli = {
      enable = mkEnableOption ''
        Whether to install the Wally CLI, a tool for flashing ZSA keyboards.
      '';
    };
  };

  config = mktif cfg.enable (mkMerge [
    { hardware.keyboard.zsa.enable = true; }
    (mkIf cfg.wally-cli.enable {
      environment.systemPackages = [ pkgs.wally-cli ];
    })
  ]);
}
