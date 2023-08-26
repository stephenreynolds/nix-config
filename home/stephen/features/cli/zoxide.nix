{
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  home.persistence = {
    "/persist/home/stephen".directories = [
      {
        directory = ".local/share/zoxide";
        method = "symlink";
      }
    ];
  };
}
