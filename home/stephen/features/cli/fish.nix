{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf;
  hasNeovim = config.programs.neovim.enable;
  hasKitty = config.programs.kitty.enable;
in
{
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
      jqless = "jq -C | less -r";

      n = "nix";
      nd = "nix develop -c $SHELL";
      ns = "nix shell";
      nsn = "nix shell nixpkgs#";
      nb = "nix build";
      nbn = "nix build nixpkgs#";
      nf = "nix flake";

      nr = "nixos-rebuild --flake .";
      nrs = "nixos-rebuild --flake . switch";
      snr = "sudo nixos-rebuild --flake .";
      snrs = "sudo nixos-rebuild --flake . switch";
      hm = "home-manager --flake .";
      hms = "home-manager --flake . switch";

      run = "nix run nixpkgs#";

      e = mkIf hasNeovim "nvim";

      cik = mkIf hasKitty "clone-in-kitty --type os-window";
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
      ''
        set --global KITTY_INSTALLATION_DIR "${pkgs.kitty}/lib/kitty"
        set --global KITTY_SHELL_INTEGRATION enabled
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
      '' +
      # Use vim bindings and cursors
      ''
        fish_vi_key_bindings
        set fish_cursor_default     block      blink
        set fish_cursor_insert      line       blink
        set fish_cursor_replace_one underscore blink
        set fish_cursor_visual      block
      '';
  };
}
