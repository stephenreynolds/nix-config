{ config, lib, pkgs, ... }:

let cfg = config.modules.dev.latex;
in {
  options.modules.dev.latex = {
    enable = lib.mkEnableOption "Whether to install LaTeX";
    packages = lib.mkOption {
      type = lib.types.attrs;
      default = pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-small collection-fontsrecommended;
      };
      description = "LaTeX packages to install";
    };
  };

  config = lib.mkIf cfg.enable { hm.home.packages = [ cfg.packages ]; };
}
