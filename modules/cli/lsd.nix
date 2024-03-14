{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.modules.cli.lsd;
in {
  options.modules.cli.lsd = {
    enable = mkEnableOption "Enable lsd, an ls alternative";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.programs.lsd = {
        enable = true;
        settings = { date = "relative"; };
      };
    }

    (mkIf config.modules.cli.shell.fish.enable {
      hm.programs.fish.shellAbbrs = {
        ls = "lsd";
        lsa = "lsd -A";
        lsl = "lsd -l";
        lsla = "lsd -lA";
        lst = "lsd --tree";
        lslt = "lsd -l --tree";
        tree = "lsd --tree";
      };
    })
  ]);
}
