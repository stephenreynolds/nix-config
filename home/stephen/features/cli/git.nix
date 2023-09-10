{ pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Stephen Reynolds";
    userEmail = "mail@stephenreynolds.dev";
    lfs.enable = true;
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-number = true;
        features = "decorations interactive";
      };
    };
    extraConfig = {
      core = {
        editor = "nvim";
        whitespace.tabwidth = 4;
      };
      color.ui = true;
      init.defaultBranch = "main";
      merge.conflictStyle = "diff3";
      pull.rebase = true;
      diff.colorMoved = "default";
      credential.helper =
        lib.mkIf (builtins.getEnv "WSL_DISTRO_NAME" != "")
        "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
    };
    ignores = [
      ".direnv"
    ];
  };
}
