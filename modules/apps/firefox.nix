{ config, lib, inputs, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkMerge mapAttrs types;
  cfg = config.modules.apps.firefox;
in
{
  options.modules.apps.firefox = {
    enable = mkEnableOption "Whether to enable Mozilla Firefox";
    profiles = mkOption {
      type = types.attrs;
      default = { };
      description = "Attribute set of Firefox profiles.";
    };
    defaultBrowser =
      mkEnableOption "Whether to set Firefox as the default browser";
    speechSynthesisSupport = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable speech synthesis support";
    };
    extraProfileConfig = mkOption {
      type = types.attrsOf (types.submodule ({ config, name, ... }: {
        options = {
          name = mkOption {
            type = types.str;
            default = name;
            description = "Name of the Firefox profile";
          };
          userChrome = {
            onebar = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to use the Firefox OneBar theme";
            };
            hideBloat = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to hide some UI builtins.elements";
            };
          };
          settings = {
            hideBookmarksToolbar = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to hide the bookmarks toolbar";
            };
            tabManager = {
              enable = mkOption {
                type = types.bool;
                default = false;
                description = "Whether to enable the tab manager";
              };
            };
            pocket = {
              enable = mkOption {
                type = types.bool;
                default = false;
                description = "Whether to enable Pocket";
              };
            };
            harden = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to harden Firefox";
            };
            newTabPage = {
              topSitesRows = mkOption {
                type = types.int;
                default = 3;
                description = "Number of rows of top sites";
              };
            };
            devtools = {
              keybindings = mkOption {
                type = types.enum [ "default" "emacs" "sublime" "vim" ];
                default = "default";
                description = "Keybindings to use in dev tools";
              };
              remoteDebugger = {
                enable = mkEnableOption "Whether to enable remote debugging";
              };
            };
          };
          search = {
            default = mkOption {
              type = types.str;
              default = "Google";
              description = "Default search engine";
            };
            brave = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to enable Brave Search";
            };
            phind = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to enable Phind";
            };
            youtube = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to enable YouTube search";
            };
            github = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to enable GitHub search";
            };
            sourcegraph = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to enable SourceGraph search";
            };
            nix-packages = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to enable Nix Packages search";
            };
            nix-options = mkOption {
              type = types.bool;
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

  config = mkIf cfg.enable (mkMerge [
    {
      hm.programs.firefox.enable = true;

      hm.home.sessionVariables.MOZ_USE_XINPUT2 = 1;

      modules.system.persist.state.home.directories = [ ".mozilla/firefox" ];
    }

    (mkIf (cfg.profiles != { }) {
      hm.programs.firefox.profiles = cfg.profiles;
    })

    (mkIf cfg.defaultBrowser {
      hm.xdg.mimeApps.defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "text/xml" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
      };
    })

    {
      hm.programs.firefox.profiles = mapAttrs
        (_: profile:
          mkMerge [
            {
              settings = with profile.settings.devtools; {
                "devtools.debugger.remote-enabled" = remoteDebugger.enable;
                "devtools.editor.keymap" = keybindings;
              };
            }

            # Use the Firefox OneBar theme
            (mkIf profile.userChrome.onebar {
              userChrome =
                builtins.readFile "${inputs.firefox-onebar}/userChrome.css";
              settings = {
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              };
            })

            # Hide some unnecessary UI builtins.elements
            (mkIf profile.userChrome.hideBloat {
              userChrome = ''
                /* Hide all tabs button */
                #alltabs-button { display: none !important; }

                /* Remove some builtins.elements from the bookmarks menu */
                .openintabs-menuseparator,
                .openintabs-menuitem,
                .bookmarks-actions-menuseparator {
                  display: none !important;
                }

                #BMB_searchBookmarks, #BMB_bookmarksShowAllTop, #BMB_viewBookmarksSidebar, #BMB_bookmarksShowAll, #BMB_bookmarksToolbar,
                html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar
                hbox#nav-bar-customization-target.customization-target toolbarbutton#bookmarks-menu-button.toolbarbutton-1.chromeclass-toolbar-additional.subviewbutton-nav
                menupopup#BMB_bookmarksPopup.cui-widget-panel.cui-widget-panelview.PanelUI-subView menuseparator {
                  display: none;
                }
              '';
            })

            # Hide bookmarks toolbar
            (mkIf profile.settings.hideBookmarksToolbar {
              settings = { "browser.toolbars.bookmarks.visibility" = "never"; };
            })

            # Enable VAAPI
            (mkIf config.modules.system.nvidia.enable {
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
            (mkIf profile.settings.harden {
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

            (mkIf config.modules.system.nvidia.enable {
              settings = {
                "widget.dmabuf.force-enabled" = true;
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
                  "Brave" = mkIf profile.search.brave {
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
                  "Phind" = mkIf profile.search.phind {
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
                  "YouTube" = mkIf profile.search.youtube {
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
                  "GitHub" = mkIf profile.search.github {
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
                  "SourceGraph" = mkIf profile.search.sourcegraph {
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
                  "Nix Packages" = mkIf profile.search.nix-packages {
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
                  "Nix Options" = mkIf profile.search.nix-options {
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
          ])
        cfg.extraProfileConfig;
    }
  ]);
}
