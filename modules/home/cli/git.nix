{ config, lib, pkgs, ... }:

let cfg = config.my.cli.git;
in {
  options.my.cli.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Git";
    };
    userName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The name to use for Git commits";
    };
    userEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The email to use for Git commits";
    };
    editor = lib.mkOption {
      type = lib.types.str;
      default = "vim";
      description = "The editor to use for Git commits";
    };
    aliases = { enable = lib.mkEnableOption "Enable aliases"; };
    signing = {
      signByDefault = lib.mkEnableOption "Sign commits by default";
      key = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The GPG key to use for signing commits";
      };
      gpg.format = lib.mkOption {
        type = lib.types.enum [ null "openpgp" "x509" "ssh" ];
        default = null;
        description = "The GPG format to use for signing commits";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      signing = {
        key = cfg.signing.key;
        signByDefault = cfg.signing.signByDefault;
      };
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
      aliases = lib.mkIf cfg.aliases.enable {
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
        co-author = ''!f() { git commit --author "$1 <$2>" -m "$3"; }; f'';
        amend-author = ''!f() { git commit --amend --author "$1 <$2>" -m "$3"; }; f'';
        authors = "!git log --format='%aN <%aE>' | sort -u";
      };
      extraConfig = {
        core = {
          editor = cfg.editor;
          whitespace.tabwidth = 4;
        };
        color.ui = true;
        init.defaultBranch = "main";
        merge.conflictStyle = "diff3";
        pull.rebase = true;
        diff.colorMoved = "default";
        gpg.format = cfg.signing.gpg.format;
      };
      ignores = [ ".direnv" ];
    };
  };
}
