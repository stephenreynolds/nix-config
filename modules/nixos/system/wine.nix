{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.my.system.wine;
in
{
  options.my.system.wine = {
    enable = mkEnableOption "Whether to enable Wine";
  };

  config = mkIf cfg.enable {
    my.system.pipewire.support32Bit = mkForce true;
    my.system.nvidia.support32Bit = mkForce true;

    environment.sessionVariables = { WINEDEBUG = "-all"; };
  };
}
