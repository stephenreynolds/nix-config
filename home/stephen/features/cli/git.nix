{ pkgs, lib, config, ... }:
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
    };
    ignores = [
      ".direnv"
    ];
  };
}
