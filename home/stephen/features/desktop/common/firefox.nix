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
        violentmonkey
        sponsorblock
        reddit-enhancement-suite
        stylus
      ];
      search = {
        default = "Google";
        force = true;
        engines = {
          "Google".metaData.alias = "@g";
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
                { name = "channel"; value = "unstable"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "Nix Options" = {
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
                { name = "channel"; value = "unstable"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
          "YouTube" = {
            urls = [{
              template = "https://www.youtube.com/results";
              params = [
                { name = "search_query"; value = "{searchTerms}"; }
              ];
            }];
            definedAliases = [ "@yt" ];
          };

          "Bing".metaData.hidden = true;
          "DuckDuckGo".metaData.hidden = true;
          "Amazon.com".metaData.hidden = true;
          "eBay".metaData.hidden = true;
          "Wikipedia (en)".metaData.hidden = true;
        };
      };
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
      userChrome =
      ''
        :root {
          --panel-hide-offset: -70px;
          --opacity-when-hidden: 0.00;
        }

        /* Auto-hide address bar */
        #navigator-toolbox {
          position: fixed !important;
          display: block;
          width: 100%;
          transition: margin-top 82ms 33ms linear, opacity 82ms 33ms linear !important;
          transition-delay: 0.25s !important;
          z-index: 1;
          opacity: 1;
          /* Disabled the borders, as the bottom one seemed to have unwanted top padding sometimes */
          border: none !important;
        }

        #navigator-toolbox:not(:focus-within):not(:hover) {
          margin-top: var(--panel-hide-offset);
          opacity: var(--opacity-when-hidden);
        }

        #navigator-toolbox.auto-hide-cursor {
          transition: margin-top 82ms 33ms linear, opacity 82ms 33ms linear !important;
        }

        #navigator-toolbox:focus-within {
          transition: margin-top 82ms 33ms linear, opacity 82ms 33ms linear !important;
          margin-top: 0px !important;
          opacity: 1 !important;
        }

        /* Disable auto-hiding when in 'customize' mode */
        :root[customizing] #navigator-toolbox{
          position: relative !important;
          opacity: 1 !important;
          margin-top: 0px;
        }

        /* Hide the close button */
        .titlebar-buttonbox-container{ display:none }
        .titlebar-spacer[type="post-tabs"]{ display:none }

        /* Remove some elements from the bookmarks menu */
        .openintabs-menuseparator,
        .openintabs-menuitem,
        .bookmarks-actions-menuseparator {
          display: none !important;
        }

        #BMB_searchBookmarks, #BMB_bookmarksShowAllTop, #BMB_viewBookmarksSidebar, #BMB_bookmarksShowAll, #BMB_bookmarksToolbar, html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbarbutton#bookmarks-menu-button.toolbarbutton-1.chromeclass-toolbar-additional.subviewbutton-nav menupopup#BMB_bookmarksPopup.cui-widget-panel.cui-widget-panelview.PanelUI-subView menuseparator {
          display: none;
        }
      '';
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

  nixpkgs.config.firefox.speechSynthesisSupport = true;
}
