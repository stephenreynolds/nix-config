{
  description = "My Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
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

  outputs = { self, nixpkgs, home-manager, haumea, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      pkgsFor = nixpkgs.legacyPackages;

      systems = [ "x86_64-linux" ];

      forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});

      hosts = haumea.lib.load {
        src = ./hosts;
        loader = haumea.lib.loaders.path;
      };

      users = haumea.lib.load {
        src = ./home;
        loader = haumea.lib.loaders.path;
      };

      mapModules = path: lib.attrsets.collect builtins.isPath (haumea.lib.load {
        src = path;
        loader = haumea.lib.loaders.path;
      });

      nixosModules = mapModules ./modules/nixos;
      homeManagerModules = mapModules ./modules/home;
    in
    {
      devShells = forEachSystem (pkgs: { default = import ./shell.nix { inherit pkgs; }; });
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations =
        lib.mapAttrs
          (hostName: host:
            lib.nixosSystem {
              modules = [
                { networking.hostName = lib.mkDefault hostName; }
                host.default
              ] ++ nixosModules;
              specialArgs = { inherit inputs outputs; };
            }
          )
          hosts;

      homeConfigurations =
        lib.mapAttrs
          (userHome: home:
            lib.homeManagerConfiguration {
              modules = [ home.default ] ++ homeManagerModules;
              pkgs = pkgsFor.x86_64-linux;
              extraSpecialArgs = { inherit inputs outputs; };
            }
          )
          users;
    };
}
