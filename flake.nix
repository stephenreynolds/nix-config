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
