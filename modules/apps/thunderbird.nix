{ config, lib, ... }:

let cfg = config.modules.apps.thunderbird;
in {
  options.modules.apps.thunderbird = {
    enable = lib.mkEnableOption "Whether to install Mozilla Thunderbird";
    profiles = lib.mkOption {
      type = lib.types.attrs;
      description = "Thunderbird profiles to create";
    };
  };

  config = lib.mkIf cfg.enable {
    hm.programs.thunderbird = {
      enable = true;
      profiles = cfg.profiles;
    };
  };
}
