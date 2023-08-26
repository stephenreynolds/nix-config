{ pkgs, inputs, ...}:
let
  addons = inputs.firefox-addons.packages.${pkgs.system};
in
{
  # TODO: Add custom theme
  programs.firefox = {
    enable = true;
    profiles.stephen = {
      bookmarks = { };
      extensions = with addons; [
        ublock-origin
        bitwarden
        violentmonkey
        sponsorblock
        reddit-enhancement-suite
      ];
      settings = {
        "browser.disableResetPrompt" = true;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
        "extensions.pocket.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "dom.security.https_only_mode" = true;
        "privacy.trackingprotection.enabled" = true;
        "browser.discovery.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.newtabpage.activity-stream.topSitesRows" = 3;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };

  home.persistence = {
    "/persist/home/stephen".directories = [ ".mozilla/firefox" ];
  };
}
