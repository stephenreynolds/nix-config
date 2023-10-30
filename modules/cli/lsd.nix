{ config, lib, ... }:
with lib;
let
  cfg = config.modules.cli.lsd;
in
{
  options.modules.cli.lsd = {
    enable = mkEnableOption "Enable lsd, an ls alternative";
  };

  config = mkIf cfg.enable {
    hm.programs.lsd = {
      enable = true;
      enableAliases = true;
      settings = {
        date = "relative";
      };
    };
  };
}
