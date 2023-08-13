{ pkgs, inputs, ...}:
let
  addons = inputs.firefox-addons.packages.${pkgs.system};
in
{
  programs.firefox = {
    enable = true;
    profiles.stephen = {
      bookmarks = { };
      extensions = with addons; [
        ublock-origin
      ];
      settings = {
        "browser.disableResetPrompt" = true;
	"browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
	"browser.shell.checkDefaultBrowser" = false;
	"browser.shell.defaultBrowserCheckCount" = 1;
	"dom.security.https_only_mode" = true;
	"privacy.trackingprotection.enabled" = true;
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
}
