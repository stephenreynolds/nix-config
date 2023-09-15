{ lib, stdenv, fetchurl, p7zip }:

stdenv.mkDerivation rec {
  name = "ttf-ms-win11-auto";

  src = fetchurl {
    url = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66751/22621.525.220925-0207.ni_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso";
    sha256 = "sha256-67x5EGcV9E9QIPd72QchsXxah3y8FaNTW5kVVJOhuz8=";
  };

  nativeBuildInputs = [ p7zip ];

  sourceRoot = ".";

  dontUnpack = true;

  installPhase = ''
    7z x ${src} sources/install.wim
    7z e sources/install.wim Windows/{Fonts/"*".{ttf,ttc},System32/Licenses/neutral/"*"/"*"/license.rtf} -ofonts

    install -Dm644 fonts/*.{ttf,ttc} -t "$out/share/fonts/TTF"
    install -Dm644 fonts/license.rtf -t "$out/share/licenses/${name}"

    rm -rf sources
    rm -rf fonts
  '';

  meta = {
    description = "Microsoft Windows 11 fonts";
    homepage = "https://www.microsoft.com/typography/fonts/product.aspx?PID=164";
    license = lib.licenses.unfree;
  };
}
