{ config, lib, inputs, pkgs, ... }:

let cfg = config.modules.apps.firefox;
in {
  options.modules.apps.firefox = {
    enable = lib.mkEnableOption "Whether to enable Mozilla Firefox";
    profiles = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Attribute set of Firefox profiles.";
    };
    defaultBrowser =
      lib.mkEnableOption "Whether to set Firefox as the default browser";
    speechSynthesisSupport = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable speech synthesis support";
    };
    extraProfileConfig = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ config, name, ... }: {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = name;
            description = "Name of the Firefox profile";
          };
          userChrome = {
            onebar = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to use the Firefox OneBar theme";
            };
            hideBloat = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to hide some UI builtins.elements";
            };
          };
          settings = {
            hideBookmarksToolbar = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to hide the bookmarks toolbar";
            };
            tabManager = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to enable the tab manager";
              };
            };
            pocket = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to enable Pocket";
              };
            };
            harden = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to harden Firefox";
            };
            newTabPage = {
              topSitesRows = lib.mkOption {
                type = lib.types.int;
                default = 3;
                description = "Number of rows of top sites";
              };
            };
          };
          search = {
            default = lib.mkOption {
              type = lib.types.str;
              default = "Google";
              description = "Default search engine";
            };
            brave = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to enable Brave Search";
            };
            phind = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to enable Phind";
            };
            youtube = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to enable YouTube search";
            };
            github = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to enable GitHub search";
            };
            sourcegraph = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to enable SourceGraph search";
            };
            nix-packages = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to enable Nix Packages search";
            };
            nix-options = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to enable Nix Options search";
            };
          };
        };
      }));

      default = { };
      description = "Extra configuration for Firefox profiles";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hm.programs.firefox.enable = true;

      hm.home.sessionVariables.MOZ_USE_XINPUT2 = 1;

      modules.system.persist.state.home.directories = [ ".mozilla/firefox" ];
    }

    (lib.mkIf (cfg.profiles != { }) {
      hm.programs.firefox.profiles = cfg.profiles;
    })

    (lib.mkIf cfg.defaultBrowser {
      hm.xdg.mimeApps.defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "text/xml" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
      };
    })

    {
      hm.programs.firefox.profiles = (lib.mapAttrs (_: profile:
        lib.mkMerge [
          # Use the Firefox OneBar theme
          (lib.mkIf profile.userChrome.onebar {
            userChrome =
              builtins.readFile "${inputs.firefox-onebar}/userChrome.css";
            settings = {
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            };
          })

          # Hide some unnecessary UI builtins.elements
          (lib.mkIf profile.userChrome.hideBloat {
            userChrome = ''
              /* Hide all tabs button */
              #alltabs-button { display: none !important; }

              /* Remove some builtins.elements from the bookmarks menu */
              .openintabs-menuseparator,
              .openintabs-menuitem,
              .bookmarks-actions-menuseparator {
                display: none !important;
              }

              #BMB_searchBookmarks, #BMB_bookmarksShowAllTop, #BMB_viewBookmarksSidebar, #BMB_bookmarksShowAll, #BMB_bookmarksToolbar, html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbarbutton#bookmarks-menu-button.toolbarbutton-1.chromeclass-toolbar-additional.subviewbutton-nav menupopup#BMB_bookmarksPopup.cui-widget-panel.cui-widget-panelview.PanelUI-subView menuseparator {
                display: none;
              }
            '';
          })

          # Hide bookmarks toolbar
          (lib.mkIf profile.settings.hideBookmarksToolbar {
            settings = { "browser.toolbars.bookmarks.visibility" = "never"; };
          })

          # Enable VAAPI
          (lib.mkIf config.modules.system.nvidia.enable {
            settings = { "media.ffmpeg.vaapi.enabled" = "true"; };
          })

          # Enable Pocket
          {
            settings = {
              "extensions.pocket.enabled" = profile.settings.pocket.enable;
            };
          }

          # Enable tab manager
          {
            settings = {
              "browser.tabs.tabmanager.enabled" =
                profile.settings.tabManager.enable;
            };
          }

          # Disable tbuiltins.elemetry
          (lib.mkIf profile.settings.harden {
            settings = {
              "browser.disableResetPrompt" = true;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" =
                false;
              "browser.newtabpage.activity-stream.feeds.system.topstories" =
                false;
              "extensions.pocket.enabled" = profile.settings.pocket.enable;
              "browser.shell.checkDefaultBrowser" = false;
              "browser.shell.defaultBrowserCheckCount" = 1;
              "dom.security.https_only_mode" = true;
              "privacy.trackingprotection.enabled" = true;
              "browser.discovery.enabled" = false;
              "app.shield.optoutstudies.enabled" = false;
              "browser.newtabpage.activity-stream.tbuiltins.elemetry" = false;
            };
          })

          # Set number of rows of top sites
          {
            settings = {
              "browser.newtabpage.activity-stream.topSitesRows" =
                profile.settings.newTabPage.topSitesRows;
            };
          }

          # Configure search engines
          {
            search = {
              default = profile.search.default;
              force = true;
              engines = {
                "Google".metaData.alias = "@g";
                "Brave" = lib.mkIf profile.search.brave {
                  urls = [{
                    template = "https://search.brave.com/search";
                    params = [{
                      name = "q";
                      value = "{searchTerms}";
                    }];
                  }];
                  iconUpdateURL =
                    "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-logo-small.bae4361b.svg";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "@b" ];
                };
                "Phind" = lib.mkIf profile.search.phind {
                  urls = [{
                    template = "https://www.phind.com/search";
                    params = [{
                      name = "q";
                      value = "{searchTerms}";
                    }];
                  }];
                  iconUpdateURL = "https://www.phind.com/images/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "@p" ];
                };
                "YouTube" = lib.mkIf profile.search.youtube {
                  urls = [{
                    template = "https://www.youtube.com/results";
                    params = [{
                      name = "search_query";
                      value = "{searchTerms}";
                    }];
                  }];
                  iconUpdateURL =
                    "https://www.youtube.com/s/desktop/dbf5c200/img/favicon_144x144.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "@yt" ];
                };
                "GitHub" = lib.mkIf profile.search.github {
                  urls = [{
                    template = "https://github.com/search";
                    params = [
                      {
                        name = "type";
                        value = "code";
                      }
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }];
                  iconUpdateURL =
                    "https://github.githubassets.com/favicons/favicon.svg";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "@gh" ];
                };
                "SourceGraph" = lib.mkIf profile.search.sourcegraph {
                  urls = [{
                    template = "https://sourcegraph.com/search";
                    params = [{
                      name = "q";
                      value = "{searchTerms}";
                    }];
                  }];
                  iconUpdateURL = "https://sourcegraph.com/favicon.ico";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "@sg" ];
                };
                "Nix Packages" = lib.mkIf profile.search.nix-packages {
                  urls = [{
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                      {
                        name = "channel";
                        value = "unstable";
                      }
                    ];
                  }];
                  icon =
                    "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@np" ];
                };
                "Nix Options" = lib.mkIf profile.search.nix-options {
                  urls = [{
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                      {
                        name = "channel";
                        value = "unstable";
                      }
                    ];
                  }];
                  icon =
                    "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@no" ];
                };

                "Bing".metaData.hidden = true;
                "DuckDuckGo".metaData.hidden = true;
                "Amazon.com".metaData.hidden = true;
                "eBay".metaData.hidden = true;
                "Wikipedia (en)".metaData.hidden = true;
              };
            };
          }
        ]) cfg.extraProfileConfig);
    }
  ]);
}
