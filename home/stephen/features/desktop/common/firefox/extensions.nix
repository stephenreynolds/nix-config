{ pkgs, inputs, ... }:
let
  addons = inputs.firefox-addons.packages.${pkgs.system};
in
{
  programs.firefox.profiles.stephen.extensions = with addons; [
    ublock-origin
    violentmonkey
    sponsorblock
    reddit-enhancement-suite
    stylus
    tridactyl
  ];

  programs.firefox.package = pkgs.firefox.override {
    cfg = {
      enableTridactylNative = true;
    };
  };
}

