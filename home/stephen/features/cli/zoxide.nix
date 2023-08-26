{
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  home.persistence = {
    "/persist/home/stephen".directories = [
      ".local/share/zoxide"
    ];
  };
}
