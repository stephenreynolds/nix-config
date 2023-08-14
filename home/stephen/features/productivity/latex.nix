{ pkgs, ... }:
let
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
    scheme-small
    collection-fontsrecommended;
  };
in
{
  home.packages = [ tex ];
}
