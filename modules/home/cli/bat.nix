{ config, lib, ... }:

let cfg = config.my.cli.bat;
in {
  options.my.cli.bat = {
    enable = lib.mkEnableOption "Whether to enable bat";
    theme = lib.mkOption {
      type = lib.types.str;
      default = "base16";
      description = "The theme to use";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config.theme = cfg.theme;
    };
  };
}
