{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mailspring
  ];

  home.persistence = {
    "/persist/home/stephen".directories = [
      ".config/Mailspring"
    ];
  };
}
