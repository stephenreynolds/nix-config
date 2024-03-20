{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  name = "deadnix-check";
  src = ../.;
  dontBuild = true;
  doCheck = true;
  nativeBuildInputs = [ pkgs.deadnix ];
  checkPhase = ''
    deadnix --fail
  '';
  installPhase = ''
    mkdir "$out"
  '';
}
