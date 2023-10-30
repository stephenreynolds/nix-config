{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.cli.gh;
in {
  options.modules.cli.gh = {
    enable = mkEnableOption "Enable GitHub CLI";
    extensions = {
      markdown-preview = mkOption {
        type = types.bool;
        default = true;
        description = "Enable markdown previewer";
      };
    };
  };

  config = mkIf cfg.enable {
    hm.programs.gh = {
      enable = true;
      extensions =
        mkIf cfg.extensions.markdown-preview [ pkgs.gh-markdown-preview ];
    };
  };
}
