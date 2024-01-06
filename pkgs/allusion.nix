{ appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "allusion";
  version = "1.0.0-rc.10";

  src = fetchurl {
    url =
      "https://github.com/allusion-app/Allusion/releases/download/v${version}/Allusion-${version}.AppImage";
    sha256 = "sha256-5bBQjjb2vs3+s1r7+GOSVQbRBc8eyWjQFAlI3/mUh/k=";
  };

  extraInstallCommands =
    let appimageContents = appimageTools.extract { inherit src; name = pname; };
    in /* bash */ ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
}
