{
  programs.firefox.profiles.stephen.settings = {
    # Enable user stylesheets
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    # Disable bookmarks toolbar
    "browser.toolbars.bookmarks.visibility" = "never";
    # Set default bookarks location
    "browser.bookmarks.defaultLocation" = "menu________";
    # Disable tab manager
    "browser.tabs.tabmanager.enabled" = false;
    # Disable Firefox View
    "browser.tabs.firefox-view" = false;
    # Set top sites rows
    "browser.newtabpage.activity-stream.topSitesRows" = 3;
    # Hide Firefox account button from toolbar
    "identity.fxaccounts.toolbar.enabled" = false;

    # Enable tracking protection
    "privacy.trackingprotection.enabled" = true;

    # Disable about:config warning
    "browser.aboutConfig.showWarning" = false;

    # Set startup homepage
    "browser.startup.page" = 1;
    "browser.startup.homepage" = "about:home";
    # Disable Activity Stream on new windows and tab pages
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.feeds.snippets" = false;
    "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;

    # Disable auto-installing updates
    "app.update.auto" = false;

    # Disable addons recommendations (using Google Analytics)
    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "browser.discovery.enabled" = false;

    # Disable telemetry
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    "browser.ping-centre.telemetry" = false;
    "beacon.enabled" = false;

    # Disable studies
    "app.shield.optoutstudies.enabled" = false;
    # Disable Normandy/Shield
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";

    # Disable crash reports
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;

    # Disable form autofill
    "browser.formfill.enable" = false;
    "extensions.formautofill.addresses.enabled" = false;
    "extensions.formautofill.available" = "off";
    "extensions.formautofill.creditCards.available" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "extensions.formautofill.heuristics.enabled" = false;
    # Disable sponsored location bar contextual suggestions
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;

    # Disable saving passwords
    "signon.rememberSignons" = false;
    # Disable autofill login and passwords
    "signon.autofillforms" = false;
    # Disable formless login capture for password manager
    "signon.formlessCapture.enabled" = false;
    # Harden against potential credentials phishing
    "network.auth.subresource-http-auth-allow" = 0;

    # Enable HTTPS-only mode in all windows
    "dom.security.https_only_mode" = true;

    # Disable Pocket extension
    "extensions.pocket.enabled" = false;
    # Disable Screenshots extension
    "extensions.Screenshots.disabled" = true;

    # Disable reset prompt
    "browser.disableResetPrompt" = true;
    # Disable checking if Firefox is the default browser
    "browser.shell.checkDefaultBrowser" = false;
    "browser.shell.defaultBrowserCheckCount" = 1;
  };
}
