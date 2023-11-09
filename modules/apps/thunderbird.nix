{ config, lib, ... }:
with lib;
let cfg = config.modules.apps.thunderbird;
in {
  options.modules.apps.thunderbird = {
    enable = mkEnableOption "Whether to install Mozilla Thunderbird";
    profiles = mkOption {
      type = types.attrs;
      description = "Thunderbird profiles to create";
    };
  };

  config = mkIf cfg.enable {
    hm.programs.thunderbird = {
      enable = true;
      profiles = cfg.profiles;
    };
  };
}
