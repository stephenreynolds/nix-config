{ config, pkgs, ... }:
let
  inherit (config.colorscheme) colors;

  mailspring-wrapped = pkgs.symlinkJoin {
    name = "mailspring";
    paths = [ pkgs.mailspring ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/mailspring --add-flags "--disable-gpu"
    '';
  };
in
{
  home.packages = [
    mailspring-wrapped
  ];

  xdg.desktopEntries.Mailspring = {
    name = "Mailspring";
    genericName = "Mail Client";
    exec = "mailspring --disable-gpu %U";
    icon = "mailspring";
    categories = [ "GNOME" "GTK" "Network" "Email" ];
    mimeType = [ "x-scheme-handle/mailto" "x-scheme-handler/mailspring" ];
    startupNotify = true;
    actions = {
      "NewMessage" = {
        exec = "mailspring mailto:";
      };
    };
  };

  xdg.configFile."Mailspring-package.json" = {
    enable = true;
    target = "Mailspring/packages/nix-colors/package.json";
    text = ''
      {
        "name": "nix-colors",
        "title": "Mailspring theme using nix-colors",
        "displayName": "nix-colors",
        "theme": "ui",
        "version": "1.1.1",
        "description": "nix-colors",
        "license": "MIT",
        "engines": {
          "mailspring": "*"
        }
      }
    '';
  };

  xdg.configFile."Mailspring-email-frame.less" = {
    enable = true;
    target = "Mailspring/packages/nix-colors/styles/email-frame.less";
    text = ''
      @import 'ui-variables';
      .ignore-in-parent-frame {
        #inbox-html-wrapper, #inbox-plain-wrapper {
          color: @text-color-prefilter !important;
          blockquote {
            border-color: @text-color-prefilter;
          }
          filter: @message-filter;
          > table,
          > :not(table) > table,
          > :not(table) > :not(table) > table,
          > :not(table) > :not(table) > :not(table) > table {
              padding: 10px;
              color: black;
              background: white !important;
              a, a:hover, a:active {
                  color: unset;
              }
              filter: @message-filter-undo;
          }
          > img,
          > :not(table) > img,
          > :not(table) > :not(table) > img,
          > :not(table) > :not(table) > :not(table) > img,
          > :not(table) > :not(table) > :not(table) > :not(table) img {
              filter: @message-filter-undo;
          }
          > :not(table),
          > :not(table) > :not(table),
          > :not(table) > :not(table) > :not(table),
          > :not(table) > :not(table) > :not(table) > :not(table) {
            background: transparent !important; // e.g. sidebars in Stack Overflow emails
          }
        }
      }
      #print-header,
      h1.print-subject,
      .print-participants,
      #message-list #inbox-html-wrapper {
        color: black;
        a, a:hover, a:active {
          color: unset;
        }
      }
      #message-list #inbox-html-wrapper {
        filter: unset;
        > table,
        > :not(table) > table,
        > :not(table) > :not(table) > table,
        > :not(table) > :not(table) > :not(table) > table {
          filter: unset;
        }

        > img,
        > :not(table) > img,
        > :not(table) > :not(table) > img,
        > :not(table) > :not(table) > :not(table) > img,
        > :not(table) > :not(table) > :not(table) > :not(table) img {
          filter: unset;
        }
      }
    '';
  };

  xdg.configFile."Mailspring-ui-variables.less" = {
    enable = true;
    target = "Mailspring/packages/nix-colors/styles/ui-variables.less";
    text = ''
      @import "base/ui-variables";

      @accent-primary: #${colors.base07};
      @accent-primary-dark: @accent-primary;

      @background-primary: #${colors.base00};
      @background-off-primary: #${colors.base00};
      @background-secondary: #${colors.base02};
      @background-tertiary: #${colors.base02};

      @border-color-primary: #${colors.base01};
      @border-color-secondary: #${colors.base01};
      @border-color-tertiary: @accent-primary;
      @border-color-divider: #${colors.base01};

      @text-color: #${colors.base05};
      @text-color-subtle: shade(#${colors.base05}, 20%);
      @text-color-very-subtle: shade(#${colors.base05}, 37%);
      @text-color-inverse: #${colors.base05};
      @text-color-inverse-subtle: shade(#${colors.base05}, 10%);
      @text-color-inverse-very-subtle: shade(#${colors.base05}, 10%);
      @text-color-heading: shade(#${colors.base05}, 10%);

      @text-color-link: @accent-primary;
      @text-color-link-hover: #${colors.base06};
      @text-color-link-active: @accent-primary;

      @btn-default-bg-color: #${colors.base02};
      @dropdown-default-bg-color: #${colors.base02};

      @input-bg: #${colors.base02};
      @input-border: #${colors.base02};

      @list-bg: #${colors.base02};
      @list-border: #${colors.base02};
      @list-selected-color: @text-color-inverse;
      @list-focused-color: #${colors.base00};

      @toolbar-background-color: #${colors.base01};
      @panel-background-color: #${colors.base01};

      @text-color-prefilter:    @text-base-prefilter;
      @text-base-prefilter:  spin(#fff - @text-color, 180);

      //Line below the toolbar
      .sheet-toolbar {
        position: relative;
        -webkit-app-region: drag;
        border-bottom: 1px solid #${colors.base00};
      }

      //Right panel, left border
      .column-MessageListSidebar {
        border-left: transparent;
      }

      //Message panel, right border
      .flexbox-handle-horizontal div {
        height: 100%;
        box-shadow: transparent;
      }

      // Message filter
      @message-filter:       invert(100%) hue-rotate(180deg);
      @message-filter-undo:  hue-rotate(-180deg) invert(120%); // white will be a bit fainter

      @text-base-prefilter:  spin(#fff - @text-color, 180);
      //@orange-prefilter:     @accent-primary; // set manually, as hue-rotate is only an approximation of spin
      //@orange-prefilter:  spin(#fff - @accent-primary, 180); // set automatically, but suboptimally

      //to correct the colour of the links inside the mail body after applying the prefilter
      #inbox-html-wrapper > :not(table), #inbox-plain-wrapper > :not(table), #inbox-html-wrapper > :not(table) > :not(table), #inbox-plain-wrapper > :not(table) > :not(table), #inbox-html-wrapper > :not(table) > :not(table) > :not(table), #inbox-plain-wrapper > :not(table) > :not(table) > :not(table), #inbox-html-wrapper > :not(table) > :not(table) > :not(table) > :not(table), #inbox-plain-wrapper > :not(table) > :not(table) > :not(table) > :not(table) {
        a {
          color: #${colors.base02};
        }
      }

      /* Badge with counter, secondary */
      .item-count-box:not(.selected):not(.focused) {
        color: #${colors.base00};
        box-shadow: 0 0.5px 0 rgba(24, 24, 37, 1), 0 -0.5px 0 rgba(24, 24, 37, 1), 0.5px 0 0 rgba(24, 24, 37, 1), -0.5px 0 0 rgba(24, 24, 37, 1);
        background: @accent-primary
      }

      /* Badge with counter, primary, selected */
      .outline-view .item .item-count-box.alt-count {
        color: @accent-primary;
        background: #${colors.base00};
        box-shadow: none;
      }

      /* Badge with counter, primary, not selected */
      .outline-view .item .item-count-box.alt-count:not(.selected):not(.focused) {
        color: #${colors.base00};
        background: @accent-primary;
        box-shadow: none;
      }

      /* tracking icon, unopened, unfocused */
      .open-tracking-icon img.content-mask.unopened {
        background-color: #${colors.base03};
      }

      /* tracking icon, mail list, unopened, focused */
      .list-item.focused .open-tracking-icon img.content-mask.unopened, .list-item.selected .open-tracking-icon img.content-mask.unopened {
        background-color: #${colors.base03};
      }

      /* tracking icon, mail list, opened, unfocused */
      .open-tracking-icon img.content-mask.opened {
        background-color: #${colors.base05};
      }

      /* tracking icon, opened, focused */
      .list-item.focused .open-tracking-icon img.content-mask.opened, .list-item.selected .open-tracking-icon img.content-mask.opened {
        background-color: #${colors.base05};
      }

      /* tracking icon, message list, focused, more than one selected */
      .thread-list.handler-split .list-item.selected {
        color: #${colors.base00};
      }

      /* tracking icon, message list, opened */
      .open-tracking-message-status.opened img.content-mask {
        background-color: #${colors.base05};
      }

      /* tracking icon, mail list, unopened, unfocused */
      .open-tracking-icon img.content-mask.unopened {
        background-color: #${colors.base03};
      }

      //Tracking icon, toolbar activity
      .toolbar-activity .unread-count.active {
        background: @accent-primary;
        color: #${colors.base00};
      }

      //Tracking message status opened
      .open-tracking-message-status.opened {
        color: #${colors.base05};
      }

      //Tracking message status unopened
      .open-tracking-message-status.unopened {
        color: tint(#${colors.base04}, 12%);
      }

      // Account switching icon
      .account-switcher img {
        zoom: 1 !important;
        max-width: 10px;
        max-height: 6px;
        transform: none;
        background-image: none;
        background-color: @text-color-very-subtle;
        -webkit-mask-repeat: no-repeat;
        -webkit-mask-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="6" viewBox="0 0 10 6"><path fill="#FFF" d="M0 0h1l4 4 4-4h1v1L5 6 0 1z"/></svg>');
      }

      //Activity icon colour (without accent)//
      .toolbar-activity .activity-toolbar-icon {
        background: shade(#${colors.base05}, 20%);
      }

      //Search bar//
      .div.suggestions {
        &:hover {
        color:@accent-primary
        }
      }

      //Composer button //
      .button-dropdown.btn-emphasis .primary-item, .button-dropdown.btn-emphasis .secondary-picker, .button-dropdown.btn-emphasis .only-item {
        position: relative;
        color: #${colors.base00};
        font-weight: 500;
        background: @accent-primary;
        box-shadow: none;
        border: 0px solid @accent-primary;
      }

      .button-dropdown.btn-emphasis .primary-item img.content-mask, .button-dropdown.btn-emphasis .secondary-picker img.content-mask, .button-dropdown.btn-emphasis .only-item img.content-mask {
        background-color: #${colors.base00};
      }

      .button-dropdown.btn-emphasis .primary-item:active, .button-dropdown.btn-emphasis .secondary-picker:active, .button-dropdown.btn-emphasis .only-item:active {
        background: @accent-primary;
      }

      //Composer name//
      .tokenizing-field .token {
        background: linear-gradient(to bottom, #${colors.base02} 0%, #${colors.base03} 100%);
      }

      .tokenizing-field .token.selected, .tokenizing-field .token.dragging {
        color: #${colors.base00};
      }

      .tokenizing-field .token.selected .action img, .tokenizing-field .token.dragging .action img {
        background-color: #${colors.base00};
      }

      //Composer dropdown list//
      .menu .item.selected, .menu .item:active {
        background-color: #4e4947;
        color: #${colors.base05};
      }

      .div.button-dropdown.open.open-down {
        background-color: #${colors.base05};
        color: #${colors.base05};
      }

      .menu .item.selected, .menu .item:active {
        background-color: @accent-primary;
        color: #${colors.base00};
      }

      .menu .item.selected .primary, .menu .item:active .primary {
        color: #${colors.base00};
      }

      .menu .item.selected .secondary, .menu .item:active .secondary {
        color: #${colors.base02};
      }

      //Reply button
      .button-dropdown .primary-item, .button-dropdown .only-item {
        background: -webkit-gradient(linear, left top, left bottom, from(#${colors.base02}), to(#${colors.base03}));
      }

      .button-dropdown .secondary-picker {
        background: -webkit-gradient(linear, left top, left bottom, from(#${colors.base02}), to(#${colors.base03}));
      }

      .button-dropdown.open.open-down .secondary-items {
        background: #${colors.base02}
      }

      //Composer unfocused
      #message-list .message-item-wrap .message-item-white-wrap.composer-outer-wrap {
        background: #${colors.base02}
      }

      //Composer focused, borders
      #message-list .message-item-wrap .message-item-white-wrap.composer-outer-wrap.focused {
        box-shadow: 0 0 0.5px rgba(0, 0, 0, 0.28), 0 1px 1.5px rgba(0, 0, 0, 0.08), 0 0 3px @accent-primary;
      }

      .composer-inner-wrap .composer-action-bar-wrap .composer-action-bar-content.unfocused {
        background-color: #${colors.base02};
      }

      //Unsubscribe action
      .unsubscribe-action {
        color: @accent-primary;
        text-decoration: underline;
      }

      //Undo/redo floating message
      .undo-redo-toast .content {
        background: @accent-primary;
      }

      //Preferences, accounts details, background colour
      .preferences-wrap .container-accounts .accounts-content .account-details {
        background-color: #${colors.base00};
      }

      //Preferences, account lists, background colour
      .nylas-editable-list .items-wrapper {
        background-color: #${colors.base02};
      }


      // Remove box-shadow on thread list quick action buttons
      .thread-injected-quick-actions .btn {
        box-shadow: none;
      }

      // Remove gradients quick action buttons
      .thread-list .list-item .list-column-HoverActions .action.action-trash {
        background: url('../static/images/thread-list-quick-actions/ic-quick-button-trash@2x.png') center
          no-repeat,
          @accent-primary;
      }

      // Remove gradients quick action buttons
      .thread-list .list-item .list-column-HoverActions .action.action-archive {
        background: url('../static/images/thread-list-quick-actions/ic-quick-button-archive@2x.png')
          center no-repeat,
          @accent-primary;
      }

      // Remove gradients quick action buttons
      .thread-list .list-item .list-column-HoverActions .action.action-snooze {
        background: url('../static/images/thread-list-quick-actions/ic-quickaction-snooze@2x.png') center
          no-repeat,
          @accent-primary;
      }

      // Change default color of star to gray
      .thread-list .thread-icon.thread-icon-star,
      .draft-list .thread-icon.thread-icon-star {
        filter: grayscale(100%);
      }

      // Change color on message button
      #message-list {
        // Labels
        .mail-label.removable {
          color: #${colors.base00} !important;
          background: @accent-primary !important;
          box-shadow: none !important;
        }
      }

      // Change color of unread mail dot
      .thread-list, .draft-list {
        .thread-icon {
          &.thread-icon-unread {
            filter: grayscale(100%);
          }
        }
      }

      //Changing the colour of the attachment icon
      .thread-icon:not(.thread-icon-unread):not(.thread-icon-star) {
        -webkit-filter: invert(100%);
      }
      img.content-dark {
        -webkit-filter: invert(100%);
      }
      img.content-light {
        -webkit-filter: invert(100%);
      }

      .mail-label {
        -webkit-filter: contrast(110%) brightness(85%);
      }
    '';
  };
}
