{ config, lib, ... }:

let
  cfg = config.modules.cli.lsd;
in
{
  options.modules.cli.lsd = {
    enable = lib.mkEnableOption "Enable lsd, an ls alternative";
  };

  config = lib.mkIf cfg.enable {
    hm.programs.lsd = {
      enable = true;
      enableAliases = true;
      settings = {
        date = "relative";
      };
    };
  };
}
