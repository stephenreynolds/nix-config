{ lib
, stdenv
, fetchFromGitHub
, gobject-introspection
, gtk3
, libnotify
, dbus
, python3Packages
, wrapGAppsHook
}:

python3Packages.buildPythonApplication {
  name = "json-notification-daemon";
  format = "other";

  src = ./script.py;

  nativeBuildInputs = [
    gtk3
    gobject-introspection
    libnotify
    dbus
    wrapGAppsHook
  ];

  propagatedBuildInputs = [
    python3Packages.dbus-python
    python3Packages.pygobject3
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/json-notification-daemon
    chmod +x $out/bin/json-notification-daemon
  '';

  meta = with lib; {
    description = "A json notification daemon";
    license = licenses.mit;
  };
}
