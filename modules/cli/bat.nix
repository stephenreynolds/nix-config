{ config, lib, ... }:
with lib;
let cfg = config.modules.cli.bat;
in {
  options.modules.cli.bat = {
    enable = mkEnableOption "Whether to enable bat";
    theme = mkOption {
      type = types.str;
      default = "base16";
      description = "The theme to use";
    };
  };

  config = mkIf cfg.enable {
    hm.programs.bat = {
      enable = true;
      config.theme = cfg.theme;
    };
  };
}
