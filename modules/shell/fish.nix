{ config, lib, ... }:
with lib;
let cfg = config.modules.shell.fish;
in {
  options.modules.shell.fish = {
    enable = mkEnableOption "Whether to enable fish shell";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.fish = {
        enable = true;
        vendor = {
          completions.enable = true;
          config.enable = true;
          functions.enable = true;
        };
      };
    }
    {
      hm.programs.fish = {
        enable = true;
        shellAbbrs = {
          jqless = "jq -C | less -r";

          n = "nix";
          nd = "nix develop -c $SHELL";
          ns = "nix shell";
          nsn = "nix shell nixpkgs#";
          nb = "nix build";
          nbn = "nix build nixpkgs#";
          nf = "nix flake";
          nfu = "nix flake update";

          nr = "nixos-rebuild --flake .";
          nrs = "nixos-rebuild --flake . switch";
          nrb = "nixos-rebuild --flake . boot";
          snr = "sudo nixos-rebuild --flake .";
          snrs = "sudo nixos-rebuild --flake . switch";
          snrb = "sudo nixos-rebuild --flake . boot";
          hm = "home-manager --flake .";
          hms = "home-manager --flake . switch";

          run = "nix run nixpkgs#";

          lsa = "lsd -a";
          tree = "lsd --tree";
        };
      };
    }
  ]);
}
