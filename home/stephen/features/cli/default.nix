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
    ./lsd.nix
    ./mcfly.nix
    ./lf.nix
  ];
  home.packages = with pkgs; [
    distrobox
    ripgrep
    sad
    fd
    jq
    wget
    tree
    trash-cli
    t
    tt
  ];
}
