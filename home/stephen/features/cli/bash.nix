{
  programs.bash = {
    enable = true;
  };

  home.persistence = {
    "/persist/home/stephen".files = [ ".bash_history" ];
  };
}
