{
  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    keyScheme = "vim";
    fuzzySearchFactor = 2;
  };

  home.persistence = {
    "/persist/home/stephen".directories = [
      ".local/share/mcfly"
    ];
  };
}
