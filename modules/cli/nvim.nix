{ config, lib, pkgs, ... }:

let cfg = config.modules.cli.nvim;
in {
  options.modules.cli.nvim = {
    enable = lib.mkEnableOption "Enable Neovim";
    defaultEditor = lib.mkEnableOption "Set Neovim as default editor";
    configSource = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Source to use for Neovim configuration";
    };
    viAlias = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Create vi alias";
    };
    vimAlias = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Create vim alias";
    };
    vimdiffAlias = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Create vimdiff alias";
    };
  };

  config = lib.mkIf cfg.enable {
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
        haskell-language-server
        prettierd
        isort
        black
        emmet-ls
        pyright
        marksman
        ocamlPackages.ocaml-lsp
        ocamlformat
        nixpkgs-fmt
        rustfmt
        rust-analyzer
        shellcheck
        yamlfmt
        jq
        codespell
        lldb
      ];
    };

    hm.xdg.configFile.nvim.source = lib.mkIf (cfg.configSource != null) cfg.configSource;

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
