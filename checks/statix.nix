{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  name = "statix-check";
  src = ../.;
  dontBuild = true;
  doCheck = true;
  nativeBuildInputs = [ pkgs.statix ];
  checkPhase = ''
    statix check
  '';
  installPhase = ''
    mkdir "$out"
  '';
}
