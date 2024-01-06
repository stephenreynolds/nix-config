{ config, pkgs, inputs, ... }:

{
  my = {
    apps = {
      electron-mail.enable = true;
      firefox = {
        enable = true;
        defaultBrowser = true;
        vaapi.enable = true;
        extraProfileConfig.stephen = {
          userChrome = {
            onebar = true;
            hideBloat = true;
          };
          settings = {
            hideBookmarksToolbar = true;
            harden = true;
          };
          search = {
            default = "Brave";
            brave = true;
            phind = true;
            youtube = true;
            github = true;
            sourcegraph = true;
            nix-packages = true;
            nix-options = true;
          };
        };
      };
      kitty.enable = true;
      extraPackages = with pkgs; [
        celluloid
        deluge
        gimp-with-plugins
        krita
        obsidian
        my.allusion
        my.tastytrade
      ];
    };
    cli = {
      bat.enable = true;
      btop.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      git = {
        userName = "Stephen Reynolds";
        userEmail = "mail@stephenreynolds.dev";
        editor = "nvim";
        aliases.enable = true;
        signing = {
          key = "${config.home.homeDirectory}/.ssh/id_ed25519";
          gpg.format = "ssh";
          signByDefault = true;
        };
      };
      lazygit.enable = true;
      lf.enable = true;
      lsd.enable = true;
      ncmpcpp.enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
      };
      shell = {
        fish.enable = true;
        starship.enable = true;
      };
      zoxide.enable = true;
    };
    desktop = {
      fonts = {
        profiles = {
          enable = true;
          monospace = {
            family = "CaskaydiaCove Nerd Font";
            package = pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; };
          };
          regular = {
            family = "SF Pro Display";
            package = pkgs.my.apple-fonts;
          };
        };
        extraPackages = with pkgs; [
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          corefonts
          font-awesome
          inter
          material-symbols
          my.apple-fonts
          my.segoe-fluent-icons
          my.ttf-ms-win11-auto
        ];
      };
      theme = {
        enable = true;
        colorscheme = inputs.nix-colors.colorSchemes.rose-pine;
        # gtk = {
        #   iconTheme = {
        #     name = "Papirus";
        #     package = pkgs.papirus-icon-theme;
        #   };
        # };
      };
    };
    services = {
      onedrive.enable = true;
    };
    user = {
      name = "stephen";
    };
  };

  home.packages = [ pkgs.blackbox-terminal ];
}
