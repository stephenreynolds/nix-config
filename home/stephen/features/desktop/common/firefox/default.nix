{
  imports = [
    ./extensions.nix
    ./search.nix
    ./settings.nix
    ./userChrome.nix
  ];

  programs.firefox = {
    enable = true;
    profiles.stephen = {
      bookmarks = { };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };

  nixpkgs.config.firefox.speechSynthesisSupport = true;
}
