{ pkgs, ... }:
{
  # TODO: Declaratively configure nvim config
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      gcc
      gnumake
      nodejs
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
    ];
  };

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

  home.sessionVariables = {
    NVIM_SQLITE_PATH = pkgs.sqlite.out;
  };

  home.persistence = {
    "/persist/home/stephen".directories = [
      ".config/nvim"
      ".local/share/nvim"
    ];
  };
}
