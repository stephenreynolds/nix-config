{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./bat.nix
    ./direnv.nix
    ./fish.nix
    ./gh.nix
    ./git.nix
    ./lazygit.nix
    ./starship.nix
    ./tmux.nix
    ./btop.nix
    ./fzf.nix
    ./zoxide.nix
  ];
  home.packages = with pkgs; [
    distrobox
    exa
    ripgrep
    fd
    jq
    wget
  ];
}
