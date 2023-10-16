{ pkgs, inputs, ... }:
let
  addons = inputs.firefox-addons.packages.${pkgs.system};
in
{
  programs.firefox.profiles.stephen.extensions = with addons; [
    proton-pass
    reddit-enhancement-suite
    sponsorblock
    stylus
    tridactyl
    ublock-origin
    violentmonkey
  ];

  programs.firefox.package = pkgs.firefox.override {
    cfg = {
      enableTridactylNative = true;
    };
  };
}

