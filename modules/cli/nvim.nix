{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.cli.nvim;
in {
  options.modules.cli.nvim = {
    enable = mkEnableOption "Enable Neovim";
    defaultEditor = mkEnableOption "Set Neovim as default editor";
    configSource = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Source to use for Neovim configuration";
    };
    viAlias = mkOption {
      type = types.bool;
      default = true;
      description = "Create vi alias";
    };
    vimAlias = mkOption {
      type = types.bool;
      default = true;
      description = "Create vim alias";
    };
    vimdiffAlias = mkOption {
      type = types.bool;
      default = true;
      description = "Create vimdiff alias";
    };
  };

  config = mkIf cfg.enable {
    hm.programs.neovim = {
      enable = true;
      defaultEditor = cfg.defaultEditor;
      viAlias = cfg.viAlias;
      vimAlias = cfg.vimAlias;
      vimdiffAlias = cfg.vimdiffAlias;
      withNodeJs = true;
      extraPackages = with pkgs; [
        gcc
        clang-tools
        gnumake
        fzf
        unzip
        sqlite
        luajitPackages.sqlite
        wget
        go
        cargo
        luarocks
        tree-sitter
        nil
        nixpkgs-fmt
        lua-language-server
        stylua
        vscode-langservers-extracted
        nodePackages.typescript-language-server
        nodePackages.bash-language-server
        prettierd
        isort
        black
        emmet-ls
        pyright
        marksman
        ocamlPackages.ocaml-lsp
        ocamlformat
        nixfmt
        rustfmt
        rust-analyzer
        shellcheck
        yamlfmt
        jq
        codespell
        lldb
      ];
    };

    hm.xdg.configFile.nvim.source =
      mkIf (cfg.configSource != null) cfg.configSource;

    hm.xdg.desktopEntries = {
      nvim = {
        name = "Neovim";
        genericName = "Text Editor";
        comment = "Edit text files";
        exec = "nvim %F";
        icon = "nvim";
        mimeType = [
          "text/english"
          "text/plain"
          "text/x-makefile"
          "text/x-c++hdr"
          "text/x-c++src"
          "text/x-chdr"
          "text/x-csrc"
          "text/x-java"
          "text/x-moc"
          "text/x-pascal"
          "text/x-tcl"
          "text/x-tex"
          "application/x-shellscript"
          "text/x-c"
          "text/x-c++"
        ];
        terminal = true;
        type = "Application";
        categories = [ "Utility" "TextEditor" ];
      };
    };

    hm.home.sessionVariables = { NVIM_SQLITE_PATH = pkgs.sqlite.out; };
  };
}
