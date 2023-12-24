{ config, lib, ... }:

let cfg = config.my.cli.shell.fish;
in {
  options.my.cli.shell.fish = {
    enable = lib.mkEnableOption "Whether to enable the Fish shell";
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
  };
}
