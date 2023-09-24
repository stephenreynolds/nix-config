{ inputs, ... }:
{
  programs.firefox.profiles.stephen.userChrome =
    (builtins.readFile "${inputs.firefox-onebar}/userChrome.css") +
    ''
      /* Hide all tabs button */
      #alltabs-button { display: none !important; }

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
}
