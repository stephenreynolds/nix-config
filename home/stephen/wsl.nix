{ pkgs, ... }:
{
  imports = [
    ./global
    ./features/productivity/latex.nix
  ];

  home.packages = [ pkgs.wslu ];

  home.sessionVariables.BROWSER = "${pkgs.wslu}/bin/wslview";

  programs.git.extraConfig = {
    credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
  };
}
