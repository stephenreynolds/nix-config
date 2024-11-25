{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.apps.vscode;
in
{
  options.modules.apps.vscode = {
    enable = mkEnableOption "Whether to install Visual Studio Code";
  };

  config = mkIf cfg.enable {
    hm.programs.vscode = {
      enable = true;
      enableUpdateCheck = false;
    };
  };
}
