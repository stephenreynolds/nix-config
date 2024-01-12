{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.services.file-roller;
in
{
  options.my.services.file-roller = {
    enable = mkEnableOption "Whether to enable File Roller";
  };

  config = mkIf cfg.enable {
    programs.file-roller.enable = true;
  };
}
