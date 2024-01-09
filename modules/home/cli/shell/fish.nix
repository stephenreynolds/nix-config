{ config, lib, pkgs, ... }:

let cfg = config.my.cli.shell.fish;
in {
  options.my.cli.shell.fish = {
    enable = lib.mkEnableOption "Whether to enable fish";
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
plugins = [{
      name="foreign-env";
      src = pkgs.fetchFromGitHub {
        owner = "lilyball";
        repo = "nix-env.fish";
        rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
        sha256 = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
      };
    }];
      shellAbbrs = rec {
        jqless = "${pkgs.jq}/bin/jq -C | less -r";

        n = "nix";
        nd = "nix develop -c $SHELL";
        ns = "nix shell";
        nsn = "nix shell nixpkgs#";
        nb = "nix build";
        nbn = "nix build nixpkgs#";
        nf = "nix flake";
        nfu = "nix flake update";
        nfc = "nix flake check";

        nr = "nixos-rebuild --flake .";
        nrs = "nixos-rebuild --flake . switch";
        nrb = "nixos-rebuild --flake . boot";
        snr = "sudo nixos-rebuild --flake .";
        snrs = "sudo nixos-rebuild --flake . switch";
        snrb = "sudo nixos-rebuild --flake . boot";
        hm = "home-manager --flake .";
        hms = "home-manager --flake . switch";

        run = "nix run nixpkgs#";

        lsa = "${pkgs.lsd}/bin/lsd -A";
        tree = "${pkgs.lsd}/bin/lsd --tree";

        e = lib.mkIf config.programs.neovim.enable "nvim";

        g = lib.mkIf config.programs.lazygit.enable "lazygit";

        cik = lib.mkIf config.programs.kitty.enable
          "clone-in-kitty --type os-window";
        ck = cik;
      };
      shellAliases = {
        # Clear screen and scrollback
        clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
      };
      functions = {
        # Disable gretting
        fish_greeting = "";
      };
      interactiveShellInit =
        # Open command buffer in vim when alt+e is pressed
        ''
          bind \ee edit_command_buffer
        '' +
        # kitty integration
        lib.optionalString config.programs.kitty.enable /* fish */ ''
          set --global KITTY_INSTALLATION_DIR "${pkgs.kitty}/lib/kitty"
          set --global KITTY_SHELL_INTEGRATION enabled
          source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
          set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
        '' +
        # Use vim bindings and cursors
        /* fish */ ''
          fish_vi_key_bindings
          set fish_cursor_default     block      blink
          set fish_cursor_insert      line       blink
          set fish_cursor_replace_one underscore blink
          set fish_cursor_visual      block
        '' + /* fish */ ''
          set -U fish_color_autosuggestion      brblack
          set -U fish_color_cancel              -r
          set -U fish_color_command             brgreen
          set -U fish_color_comment             brmagenta
          set -U fish_color_cwd                 green
          set -U fish_color_cwd_root            red
          set -U fish_color_end                 brmagenta
          set -U fish_color_error               brred
          set -U fish_color_escape              brcyan
          set -U fish_color_history_current     --bold
          set -U fish_color_host                normal
          set -U fish_color_match               --background=brblue
          set -U fish_color_normal              normal
          set -U fish_color_operator            cyan
          set -U fish_color_param               brblue
          set -U fish_color_quote               yellow
          set -U fish_color_redirection         bryellow
          set -U fish_color_search_match        'bryellow' '--background=brblack'
          set -U fish_color_selection           'white' '--bold' '--background=brblack'
          set -U fish_color_status              red
          set -U fish_color_user                brgreen
          set -U fish_color_valid_path          --underline
          set -U fish_pager_color_completion    normal
          set -U fish_pager_color_description   yellow
          set -U fish_pager_color_prefix        'white' '--bold' '--underline'
          set -U fish_pager_color_progress      'brwhite' '--background=cyan'
        '';
    };
  };
}
