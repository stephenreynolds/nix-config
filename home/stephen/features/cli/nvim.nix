{ pkgs, inputs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
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
    ];
  };

  xdg.configFile.nvim.source = inputs.nvim-config;

  xdg.desktopEntries = {
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

  home.sessionVariables = { NVIM_SQLITE_PATH = pkgs.sqlite.out; };
}
