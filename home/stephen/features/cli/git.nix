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
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      type = "cat-file -t";
      dump = "cat-file -p";
      undo = "reset HEAD~";
      amend = "commit --amend";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      lg = "log --graph --pretty=format:'%C(yellow)%h%Creset %C(green)%ad%Creset | %s%Creset %C(red)%d%Creset %C(bold blue)[%an]%Creset' --date=relative";
      lga = "log --graph --pretty=format:'%C(yellow)%h%Creset %C(green)%ad%Creset | %s%Creset %C(red)%d%Creset %C(bold blue)[%an]%Creset' --date=relative --all";
      ls = "ls-files";
      prune = "remote prune origin";
      pristine = "reset --hard && clean -dfx";
      count = "shortlog -sn";
      cp = "cherry-pick";
      co-author = "!f() { git commit --author \"$1 <$2>\" -m \"$3\"; }; f";
      amend-author = "!f() { git commit --amend --author \"$1 <$2>\" -m \"$3\"; }; f";
      authors = "!git log --format='%aN <%aE>' | sort -u";
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
