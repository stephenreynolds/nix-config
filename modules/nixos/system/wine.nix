{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.my.apps.wine;
in
{
  options.my.apps.wine = {
    enable = mkEnableOption "Whether to enable Wine";
  };

  config = mkIf cfg.enable {
    my.system.pipewire.support32Bit = mkForce true;
    my.system.nvidia.support32Bit = mkForce true;

    environment.sessionVariables = { WINEDEBUG = "-all"; };
  };
}
