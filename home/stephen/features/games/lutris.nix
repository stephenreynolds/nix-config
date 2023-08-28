{ pkgs, ... }:
{
  home.packages = [ pkgs.lutris ];

  home.persistence = {
    "/persist/home/stephen" = {
      allowOther = true;
      directories = [
        ".config/lutris"
        ".local/share/lutris"
      ];
    };
  };
}
