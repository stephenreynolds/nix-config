{
  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    keyScheme = "vim";
  };

  home.persistence = {
    "/persist/home/stephen".files = [
      ".local/share/mcfly/history.db"
    ];
  };
}
