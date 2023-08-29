{ fetchurl, lib, stdenv, pkg-config, glib, help2man, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "preload";
  version = "0.6.4";

  src = fetchurl {
    url = "mirror://sourceforge/preload/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-0KVY6DyymlHZ2Wc27zn0tOVeQ6WJrRrsWUoEjKIvgWs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    help2man
  ];

  configureFlags = [
    "--prefix=$out"
    "--localstatedir=/var"
    "--mandir=/share/man"
    "--sbindir=/bin"
    "--sysconfdir=/etc"
  ];

  buildPhase = ''
    ./configure $configureFlags
    make
  '';

  installPhase = ''
    make DESTDIR="$out" sysconfigdir=/etc/conf.d install

    rm -rf $out/etc/rc.d
    rm -rf $out/var/lib/preload/preload.state
    rm -rf $out/var/log/preload.log
  '';

  meta = {
    description = "Makes applications run faster by prefetching binaries and shared objects";
    license = lib.licenses.gpl2;
    homepage = "http://sourceforge.net/projects/preload";
    maintainers = with lib.maintainers; [ stephenreynolds ];
    platforms = lib.platforms.linux;
  };
})
