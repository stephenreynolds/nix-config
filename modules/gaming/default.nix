{ config, lib, ... }:
with lib;
let cfg = config.modules.gaming;
in {
  options.modules.gaming = {
    memory-fix = {
      enable = mkEnableOption "Whether to enable memory fix for some games";
    };
  };

  config = mkMerge [
    (mkIf cfg.memory-fix.enable {
      boot.kernel.sysctl = { "vm.max_map_count" = 2147483642; };
    })
  ];
}
