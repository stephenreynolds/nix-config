{
  description = "My Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib?ref=v2.1.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-onebar = {
      url = "git+https://codeberg.org/Freeplay/Firefox-Onebar";
      flake = false;
    };

    nvim-config = {
      url = "github:stephenreynolds/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "nix-config";
            title = "My Nix configuration";
          };

          namespace = "my";
        };
      };
    in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-25.9.0"
        ];
      };

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
      ];

      outputs-builder = channels:
        let
          pkgs = channels.nixpkgs;
          inherit (pkgs) deadnix runCommand statix;
          inherit (lib) getExe;
        in
        {
          devShells.default = import ./shell.nix { inherit pkgs; };

          formatter = channels.nixpkgs.nixpkgs-fmt;

          checks =
            let
              mkCheck = linter:
                runCommand "lint" { } ''
                  cd ${self}
                  ${linter} 2>&1
                  touch $out
                '';
            in
            {
              statix = mkCheck "${getExe statix} check ${self}";
              deadnix = mkCheck "${getExe deadnix} -f ${self}";
            };
        };
    };
}
