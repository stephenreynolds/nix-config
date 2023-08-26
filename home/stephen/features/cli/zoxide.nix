{
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  home.persistence = {
    "/persist/home/stephen".files = [
      ".local/share/zoxide/db.zo"
    ];
  };
}
