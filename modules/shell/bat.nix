{ config, lib, ... }:
let cfg = config.modules.shell.bat;
in {
  options.modules.shell.bat = {
    enable = lib.mkEnableOption "Enable bat";
    theme = lib.mkOption {
      type = lib.types.str;
      default = "base16";
      description = "The theme to use";
    };
  };

  config = lib.mkIf cfg.enable {
    hm.programs.bat = {
      enable = true;
      config.theme = cfg.theme;
    };
  };
}
