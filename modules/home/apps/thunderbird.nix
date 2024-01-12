{ config, lib, ... }:

let
  inherit (lib) types mkOption mkEnableOption mkIf;
  cfg = config.my.apps.thunderbird;
in
{
  options.my.apps.thunderbird = {
    enable = mkEnableOption "Whether to install Mozilla Thunderbird";
    profiles = mkOption {
      type = types.attrs;
      description = "Thunderbird profiles to create";
    };
  };

  config = mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles = cfg.profiles;
    };
  };
}
