{ config, pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./bat.nix
    ./btop.nix
    ./comma.nix
    ./direnv.nix
    ./fish.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gpg.nix
    ./keyring.nix
    ./lazygit.nix
    ./lf.nix
    ./lsd.nix
    ./nvim.nix
    ./starship.nix
    ./tmux.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    distrobox
    ripgrep
    sad
    fd
    jq
    wget
    tree
    unzip
    trash-cli
    comma
    t
    tt
  ];

  home.sessionVariables = {
    GOPATH = "${config.xdg.dataHome}/go";
  };
}
