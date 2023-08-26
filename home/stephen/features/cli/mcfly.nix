{
  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    keyScheme = "vim";
  };

  home.persistence = {
    "/persist/home/stephen".directories = [
      ".local/share/mcfly"
    ];
  };
}
