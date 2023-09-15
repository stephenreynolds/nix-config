# https://github.com/Shawn8901/nix-configuration/blob/9260e6d5ff0b77296c68c5717cb92bdeb04d68e3/packages/proton-ge-custom/default.nix#L8
{ stdenv, lib, fetchurl }:

stdenv.mkDerivation (finalAttrs: {
  name = "proton-ge-custom";
  version = "GE-Proton8-14";

  src = fetchurl {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${finalAttrs.version}/${finalAttrs.version}.tar.gz";
    sha256 = "sha256-HxCymYlHwfwIyCAkOdPhXupfyv6oDOs2lm/3ccQAMiY=";
  };

  passthru.runUpdate = true;

  buildCommand = ''
    mkdir -p $out/bin
    tar -C $out/bin --strip=1 -x -f $src
  '';

  meta = with lib; {
    description = "Compatibility tool for Steam Play based on Wine and additional components";
    homepage = "https://github.com/GloriousEggroll/proton-ge-custom";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ shawn8901 ];
  };
})
