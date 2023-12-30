{ config, lib, ... }:

let cfg = config.my.cli.gh;
in {
  options.my.cli.gh = {
    enable = lib.mkEnableOption "Enable GitHub CLI";
    extensions = {
      markdown-preview = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable markdown previewer";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = true;
      settings = {
        version = 1;
        git_protocol = "ssh";
      };
    };
  };
}
