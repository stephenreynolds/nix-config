# From https://github.com/NixOS/nixpkgs/pull/260108
# Waiting to be merged into nixpkgs
{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, makeBinaryWrapper
, alsa-lib
, atk
, at-spi2-atk
, cairo
, cups
, dbus
, expat
, freetype
, glib
, glibc
, gtk3
, libdrm
, libGL
, libxkbcommon
, mesa
, nspr
, nss
, pango
, xdg-utils
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "tastytrade";
  version = "2.4.1";

  src = fetchurl {
    url =
      "https://download.tastytrade.com/desktop-2.x.x/${version}/tastytrade-${version}-1_amd64.deb";
    hash = "sha256-wWz+Bz0qpOzaf47vzzI5+w70mq5yGB5+TxJ4QNdxjk0=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg makeBinaryWrapper ];

  # The dashboard errors in ~/.tastytrade/desktop/tastytrade.log because
  # ~/.tastytrade/chromium/production/amd64/chromium is missing libraries,
  # but functionality does not appear to be significantly affected.
  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    atk
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    freetype
    glib
    glibc
    gtk3
    libdrm
    libGL
    libxkbcommon
    mesa
    nspr
    nss
    pango
    xdg-utils
    xorg.libxcb
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXxf86vm
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt/tastytrade/* $out

    mkdir $out/share/applications
    mv $out/lib/tastytrade-tastytrade.desktop $out/share/applications/tastytrade.desktop
    substituteInPlace $out/share/applications/tastytrade.desktop \
      --replace /opt/tastytrade $out \
      --replace tastyworks Finance
    echo StartupWMClass=tasty.javafx.launcher.LauncherFxApp >> $out/share/applications/tastytrade.desktop

    addAutoPatchelfSearchPath $out/lib/runtime/lib
    addAutoPatchelfSearchPath $out/lib/runtime/lib/server

    wrapProgram $out/bin/tastytrade --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath buildInputs
    }:$out/lib/runtime/lib:$out/lib/runtime/lib/server
    # tastytrade looks for the cfg file according to its process name
    mv $out/lib/app/tastytrade.cfg $out/lib/app/.tastytrade-wrapped.cfg

    runHook postInstall
  '';

  meta = {
    description = "Options, futures and stock trading brokerage";
    homepage = "https://tastytrade.com/trading-platforms/#desktop";
    changelog = "https://support.tastyworks.com/support/solutions/articles/43000435186-tastytrade-desktop-release-notes";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ prominentretail ];
    platforms = lib.platforms.linux;
    mainProgram = "tastytrade";
  };
}
