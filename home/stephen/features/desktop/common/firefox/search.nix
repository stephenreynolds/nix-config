{ pkgs, ... }:
{
  programs.firefox.profiles.stephen.search = {
    default = "Brave";
    force = true;
    engines = {
      "Google".metaData.alias = "@g";
      "Brave" = {
        urls = [{
          template = "https://search.brave.com/search";
          params = [{ name = "q"; value = "{searchTerms}"; }];
        }];
        icon = "${pkgs.brave}/share/icons/hicolor/64x64/apps/brave-browser.png";
        definedAliases = [ "@b" ];
      };
      "Phind" = {
        urls = [{
          template = "https://www.phind.com/search";
          params = [{ name = "q"; value = "{searchTerms}"; }];
        }];
        iconUpdateURL = "https://www.phind.com/images/favicon.png";
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = [ "@p" ];
      };
      "YouTube" = {
        urls = [{
          template = "https://www.youtube.com/results";
          params = [
            { name = "search_query"; value = "{searchTerms}"; }
          ];
        }];
        iconUpdateURL = "https://www.youtube.com/s/desktop/dbf5c200/img/favicon_144x144.png";
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = [ "@yt" ];
      };
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
      "Home Manager" = {
        urls = [
          {
            template = "https://rycee.gitlab.io/home-manager/options.html";
          }
        ];
        definedAliases = [ "@hm" ];
      };

      "Bing".metaData.hidden = true;
      "DuckDuckGo".metaData.hidden = true;
      "Amazon.com".metaData.hidden = true;
      "eBay".metaData.hidden = true;
      "Wikipedia (en)".metaData.hidden = true;
    };
  };
}
