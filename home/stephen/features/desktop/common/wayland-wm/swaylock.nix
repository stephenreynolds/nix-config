{ config, pkgs, ... }:
let
  image = "$HOME/Pictures/Wallpapers/Slideshow/1212315.jpg";
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      image = image;

      clock = true;
      ignore-empty-password = true;

      font = config.fontProfiles.regular.family;
      font-size = 15;

      effect-blur = "20x3";

      line-uses-inside = true;
      disable-caps-lock-text = true;
      indicator-caps-lock = true;
      indicator-idle-visible = true;

      indicator-radius = 100;
      indicator-thickness = 5;

      bs-hl-color = "d65d0e";
      ring-color = "7c6f64";
      ring-clear-color = "7c6f64";
      ring-caps-lock-color = "7c6f64";
      ring-ver-color = "7c6f64";
      ring-wrong-color = "7c6f64";
      key-hl-color = "ebdbb2";
      text-color = "fabd2f";
      text-clear-color = "fabd2f";
      text-caps-lock-color = "fabd2f";
      text-ver-color = "83a598";
      text-wrong-color = "fb4934";
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      inside-color = "00000088";
      inside-clear-color = "00000088";
      inside-ver-color = "00000088";
      inside-wrong-color = "00000088";
      separator-color = "00000000";
    };
  };
}
