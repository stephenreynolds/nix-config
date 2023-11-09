{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.dev.latex;
in {
  options.modules.dev.latex = {
    enable = mkEnableOption "Whether to install LaTeX";
    packages = mkOption {
      type = types.attrs;
      default = pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-small collection-fontsrecommended;
      };
      description = "LaTeX packages to install";
    };
  };

  config = mkIf cfg.enable { hm.home.packages = [ cfg.packages ]; };
}
