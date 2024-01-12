{ config, lib, pkgs, ... }:

let cfg = config.my.devices.zsa-keyboard;
in {
  options.my.devices.zsa-keyboard = {
    enable = lib.mkEnableOption "Whether to enable udev rules for ZSA keyboards";
    keymapp.enable = lib.mkEnableOption ''
      Whether to install keymapp, an application for ZSA keyboards
    '';
    wally-cli.enable = lib.mkEnableOption ''
      Whether to install the Wally CLI, a tool for flashing ZSA keyboards
    '';
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hardware.keyboard.zsa.enable = true;
    }

    (lib.mkIf cfg.wally-cli.enable {
      environment.systemPackages = [ pkgs.keymapp ];
    })

    (lib.mkIf cfg.wally-cli.enable {
      environment.systemPackages = [ pkgs.wally-cli ];
    })
  ]);
}
