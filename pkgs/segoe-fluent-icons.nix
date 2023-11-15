{ lib, stdenv, fetchzip }:

stdenv.mkDerivation {
  name = "Segoe Fluent Icons";

  dontConfigure = true;

  src = fetchzip {
    url = "https://download.microsoft.com/download/8/f/c/8fc7cbc3-177e-4a22-af48-2a85e1c5bffb/Segoe-Fluent-Icons.zip";
    sha256 = "sha256-MgwkgbVN8vZdZAFwG+CVYu5igkzNcg4DKLInOL1ES9A=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -R $src $out/share/fonts/truetype/
  '';

  meta = {
    description = "Microsoft Segoe Fluent Icons font";
    homepage = "https://learn.microsoft.com/en-us/windows/apps/design/downloads/#fonts";
    license = lib.licenses.unfree;
  };
}
