{
  programs.firefox.profiles.stephen.settings = {
    # Enable user stylesheets
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    # Disable bookmarks toolbar
    "browser.toolbars.bookmarks.visibility" = "never";
    # Disable tab manager
    "browser.tabs.tabmanager.enabled" = false;
    # Set top sites rows
    "browser.newtabpage.activity-stream.topSitesRows" = 3;

    # SSL settings
    "security.ssl.treat_unsafe_negotiation_as_broken" = true;
    "security.ssl3.rsa_des_ede3_sha" = false;
    "security.ssl.enable_false_start" = false;

    # Enable tracking protection
    "privacy.trackingprotection.enabled" = true;

    # Disable about:config warning
    "browser.aboutConfig.showWarning" = false;

    # Set startup homepage
    "browser.startup.page" = 1;
    "browser.startup.homepage" = "about:home";
    # Disable Activity Stream on new windows and tab pages
    "browser.newtabpage.enabled" = false;
    "browser.newtab.preload" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.feeds.snippets" = false;
    "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
    "browser.newtabpage.activity-stream.default.sites" = "";

    # Use Mozilla geolocation service instead of Google if permission is granted
    "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
    # Disable using the OS's geolocation service
    "geo.provider.use_gpsd" = false;
    "geo.provider.use_geoclue" = false;
    # Disable region updates
    "browser.region.network.url" = "";
    "browser.region.update.enabled" = false;

    # Set language for displaying webpages
    "intl.accept_languages" = "en-US, en";
    "javascript.use_us_english_locale" = true;

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

    # Disable captive portal detection
    "captivedetect.canonicalURL" = "";
    "network.captive-portal-service.enabled" = false;
    # Disable network connections checks
    "network.connectivity-service.enabled" = false;

    # Disable link prefetching
    "network.prefetch-next" = false;
    # Disable DNS prefetching
    "network.dns.disablePrefetch" = true;
    # Disable predictor
    "network.predictor.enabled" = false;
    # Disable link-mouseover opening connection to linked server
    "network.http.speculative-parallel-limit" = 0;
    # Disable IPv6
    "network.dns.disableIPv6" = true;
    # Disable GIO protocols as a potential proxy bypass vector
    "network.gio.supported-protocols" = "";
    # Disable using UNC paths (prevent proxy bypass)
    "network.file.disable_unc_paths" = true;
    # Remove special permissions for certain Mozilla domains
    "permissions.manager.defaultsUrl" = "";
    # Use Punycode in internationalized domain names to eliminate possible spoofing
    "network.IDN_show_punycode" = true;

    # Display all parts of the url in the bar
    "browser.urlbar.trimURLs" = false;
    # Disable location bar making speculative connections
    "browser.urlbar.speculativeConnect.enabled" = false;

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
    # Disable sending HTTPS request for checking HTTPS support by the server
    "dom.security.https_only_mode_send_http_background_request" = false;
    # Display advanced information on insecure connection warning pages
    "browser.xul.error_pages.expert_bad_cert" = true;
    # Disaple TLS1.3 0-RTT (round-trip time)
    "security.tls.enable_0rtt_data" = false;
    # Set OCSP to terminate the connection when a CA isn't validated
    "security.OCSP.require" = true;
    # Disaple SHA-1 certificates
    "security.pki.sha1_enforcement_level" = 1;
    # Enable strict pinning
    "security.cert_pinning.enforcement_level" = 2;
    # Enable CRLite
    "security.remote_settings.crlite_filters.enabled" = true;
    "security.pki.crlite.mode" = 2;

    # Control when to send a referer
    "network.http.referer.XOriginPolicy" = 2;
    # Control the amount of information to send
    "network.http.referer.XOriginTrimmingPolicy" = 2;

    # Force WebRTC inside the proxy
    "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
    # Force a single network interface for ICE candidates generation
    "media.peerconnection.ice.default_address_only" = true;
    # Force exclusion of private IPs from ICE candidates
    "media.peerconnection.ice.no_host" = true;

    # Enable enhanced tracking protection
    "borwser.contentblocking.category" = "strict";
    # Enable state partitioning of service workers
    "privacy.partition.serviceWorkers" = true;
    # Enable APS (Always Partition Storage)
    "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
    "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = true;

    # Block popup windows
    "dom.disable_open_during_load" = true;
    # Limit events that can cause a popup
    "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";
    # Disable Pocket extension
    "extensions.pocket.enabled" = false;
    # Disable Screenshots extension
    "extensions.Screenshots.disabled" = true;
    # Disable PDFJS wcripting
    "pdfjs.enableScripting" = false;

    # Set extensions to work on restricted domains
    "extensions.enabledScopes" = 5;
    "extensions.webextensions.restrictedDomains" = "";
    # Always display the installation prompt
    "extensions.postDownloadThirdPartyPrompt" = true;

    # Resist fingerprinting
    "privacy.resistFingerprinting" = true;
    # Set new window size rounding max values
    "privacy.window.maxInnerWidth" = 1600;
    "privacy.window.maxInnerHeight" = 900;
    # Disable mozAddonManager Web API
    "privacy.resistFingerprinting.block_mozAddonManager" = true;
    # Disable showing about:blank page when possible at startup
    "browser.startup.blankWindow" = false;

    # Disable reset prompt
    "browser.disableResetPrompt" = true;
    # Disable checking if Firefox is the default browser
    "browser.shell.checkDefaultBrowser" = false;
    "browser.shell.defaultBrowserCheckCount" = 1;
  };
}
