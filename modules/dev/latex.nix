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

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { hm.home.packages = [ cfg.packages ]; }

    (lib.mkIf config.modules.system.security.firejail.enable {
      programs.firejail.wrappedBinaries = {
        latex = {
          executable = "${cfg.packages}/bin/latex";
          profile = "${pkgs.firejail}/etc/firejail/latex.profile";
        };
        pdflatex = {
          executable = "${cfg.packages}/bin/pdflatex";
          profile = "${pkgs.firejail}/etc/firejail/pdflatex.profile";
        };
        tex = {
          executable = "${cfg.packages}/bin/tex";
          profile = "${pkgs.firejail}/etc/firejail/tex.profile";
        };
      };
    })
  ]);
}
