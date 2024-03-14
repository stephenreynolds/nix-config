{ config, lib, pkgs, ... }:

let cfg = config.modules.cli.shell.fish;
in {
  options.modules.cli.shell.fish = {
    enable = lib.mkEnableOption "Whether to enable fish";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.fish = {
        enable = true;
        vendor = {
          completions.enable = true;
          config.enable = true;
          functions.enable = true;
        };
      };
    }

    {
      hm.programs.fish = {
        enable = true;
        shellAbbrs = rec {
          jqless = "jq -C | less -r";

          n = "nix";
          nd = "nix develop -c $SHELL";
          ns = "nix shell";
          nsn = "nix shell nixpkgs#";
          nb = "nix build";
          nbn = "nix build nixpkgs#";
          nf = "nix flake";
          nfu = "nix flake update";
          nfc = "nix flake check";
          nflu = "nix flake lock --update-input";
          nfi = "nix flake init";

          nr = "nixos-rebuild --flake .";
          nrs = "nixos-rebuild --flake . switch";
          nrb = "nixos-rebuild --flake . boot";
          snr = "sudo nixos-rebuild --flake .";
          snrs = "sudo nixos-rebuild --flake . switch";
          snrb = "sudo nixos-rebuild --flake . boot";
          hm = "home-manager --flake .";
          hms = "home-manager --flake . switch";

          run = "nix run nixpkgs#";

          lsa = lib.mkIf config.hm.programs.lsd.enable "lsd -A";
          tree = lib.mkIf config.hm.programs.lsd.enable "lsd --tree";

          e = lib.mkIf config.hm.programs.neovim.enable "nvim";

          g = lib.mkIf config.hm.programs.lazygit.enable "lazygit";

          cik = lib.mkIf config.hm.programs.kitty.enable
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
          # mkdir and cd in one command
          mkcd = "mkdir -p $argv && cd $argv";
        };
        interactiveShellInit =
          # Open command buffer in vim when alt+e is pressed
          ''
            bind \ee edit_command_buffer
          '' +
          # Add more abbreviations
          /* fish */ ''
            # Add a new abbreviation where L will be replaced with | less, placing the cursor before the pipe.
            abbr -a L --position anywhere --set-cursor "% | less"

            # Add a replacement for the !! history expansion feature of bash.
            function last_history_item
              echo $history[1]
            end
            abbr -a !! --position anywhere --function last_history_item
          '' +
          # kitty integration
          lib.optionalString config.hm.programs.kitty.enable /* fish */ ''
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

      modules.system.persist.state.home.directories = [
        ".config/fish"
        ".local/share/fish"
      ];
    }
  ]);
}
