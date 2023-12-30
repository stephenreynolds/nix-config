{ config, lib, ... }:

let
  cfg = config.my.cli.lsd;
in
{
  options.my.cli.lsd = {
    enable = lib.mkEnableOption "Enable lsd, an ls alternative";
  };

  config = lib.mkIf cfg.enable {
    programs.lsd = {
      enable = true;
      enableAliases = true;
      settings = {
        date = "relative";
      };
    };
  };
}
