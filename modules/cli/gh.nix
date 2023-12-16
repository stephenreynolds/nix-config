{ config, lib, pkgs, ... }:

let cfg = config.modules.cli.gh;
in {
  options.modules.cli.gh = {
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
    hm.programs.gh = {
      enable = true;
      extensions =
        lib.mkIf cfg.extensions.markdown-preview [ pkgs.gh-markdown-preview ];
      settings = {
        version = 1;
        git_protocol = "ssh";
      };
    };
  };
}
