{ config, lib, ... }:
with lib;
let cfg = config.modules.shell.fish;
in {
  options.modules.shell.fish = {
    enable = mkEnableOption "Whether to enable fish shell";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.fish = {
        enable = true;
        vendor = {
          completions.enable = true;
          config.enable = true;
          functions.enable = true;
        };
      };
    }
    { hm.programs.fish = { enable = true; }; }
  ]);
}
