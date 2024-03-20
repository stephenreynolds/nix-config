{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.modules.cli.git;
in {
  options.modules.cli.git = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Git";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.gitAndTools.gitFull;
      description = "The Git package to install";
    };
    userName = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The name to use for Git commits";
    };
    userEmail = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The email to use for Git commits";
    };
    editor = mkOption {
      type = types.str;
      default = "vim";
      description = "The editor to use for Git commits";
    };
    aliases = { enable = mkEnableOption "Enable aliases"; };
    signing = {
      signByDefault = mkEnableOption "Sign commits by default";
      key = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The GPG key to use for signing commits";
      };
      gpg.format = mkOption {
        type = types.enum [ null "openpgp" "x509" "ssh" ];
        default = null;
        description = "The GPG format to use for signing commits";
      };
    };
  };

  config = mkIf cfg.enable {
    hm.programs.git = {
      enable = true;
      package = cfg.package;
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
      aliases = mkIf cfg.aliases.enable {
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
        lg =
          "log --graph --pretty=format:'%C(yellow)%h%Creset %C(green)%ad%Creset | %s%Creset %C(red)%d%Creset %C(bold blue)[%an]%Creset' --date=relative";
        lga =
          "log --graph --pretty=format:'%C(yellow)%h%Creset %C(green)%ad%Creset | %s%Creset %C(red)%d%Creset %C(bold blue)[%an]%Creset' --date=relative --all";
        ls = "ls-files";
        prune = "remote prune origin";
        pristine = "!git reset --hard && git clean -dfx";
        count = "shortlog -sn";
        cp = "cherry-pick";
        co-author = ''!f() { git commit --author "$1 <$2>" -m "$3"; }; f'';
        amend-author =
          ''!f() { git commit --amend --author "$1 <$2>" -m "$3"; }; f'';
        authors = "!git log --format='%aN <%aE>' | sort -u";
      };
      extraConfig = {
        core = {
          editor = cfg.editor;
          whitespace.tabwidth = 4;
        };
        color.ui = true;
        init.defaultBranch = "main";
        merge.conflictStyle = "zdiff3";
        pull.rebase = true;
        diff.colorMoved = "default";
        commit.verbose = true;
        log.date = "iso";
        push.autoSetupRemote = true;
        rerere.enable = true;
        gpg.format =
          mkIf (cfg.signing.gpg.format != null) cfg.signing.gpg.format;
      };
      ignores = [ ".direnv" ];
    };

    users.groups.git = { };
  };
}
