{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obsidian
  ];

  home.persistence = {
    "/persist/home/stephen".directories = [
      ".config/obsidian"
    ];
  };
}
