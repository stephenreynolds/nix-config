{ fetchFromGitHub, lib, stdenv, meson, ninja, pkg-config, libpulseaudio, wayland, wayland-protocols, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "SwayAudioIdleInhibit";
  version = "v0.1.1";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-XUUUUeaXO7GApwe5vA/zxBrR1iCKvkQ/PMGelNXapbA=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ libpulseaudio wayland wayland-protocols ];

  buildPase = ''
    meson build
    ninja -C build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp sway-audio-idle-inhibit $out/bin
  '';

  meta = {
    description = "Prevents swayidle from sleeping while any application is outputting or receiving audio";
    license = lib.licenses.gpl3;
    homepage = "https://github.com/ErikReider/SwayAudioIdleInhibit";
    platforms = lib.platforms.linux;
  };
})
