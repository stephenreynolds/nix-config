{ lib, stdenv, fetchurl, autoPatchelfHook, dpkg, alsa-lib, at-spi2-atk, cairo
, gtk3, libdrm, libxkbcommon, mesa, nspr, nss, pango, systemd, xorg }:

stdenv.mkDerivation {
  name = "protonmail-desktop-beta";

  src = fetchurl {
    url = "https://proton.me/download/mail/linux/ProtonMail-desktop-beta.deb";
    hash = "sha256-3FRm02Ew9GuGMXFAkwSL+FbeLyaI1SmpDU3A5eJh6TU=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    gtk3
    libdrm
    libxkbcommon
    mesa
    nspr
    nss
    pango
    xorg.libxcb
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
  ];

  runtimeDependencies = [ systemd ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/* $out

    runHook postInstall
  '';

  meta = {
    description =
      "The full Proton Mail and Proton Calendar experience from the convenience of your desktop";
    homepage = "https://proton.me/support/mail-desktop-app";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ stephenreynolds ];
    platforms = lib.platforms.linux;
    mainProgram = "proton-mail";
  };
}
