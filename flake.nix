{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";
    sops-nix.url = "github:mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    eww.url = "github:ralismark/eww/tray-3";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" ];
      forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
      inherit lib;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      templates = import ./templates;

      overlays = import ./overlays { inherit inputs outputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = {
        nixie = lib.nixosSystem {
          modules = [ ./hosts/nixie ];
          specialArgs = { inherit inputs outputs; };
        };

        nixvm = lib.nixosSystem {
          modules = [ ./hosts/nixvm ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      homeConfigurations = {
        "stephen@nixie" = lib.homeManagerConfiguration {
	        modules = [ ./home/stephen/nixie.nix ];
	        pkgs = pkgsFor.x86_64-linux;
	        extraSpecialArgs = { inherit inputs outputs; };
        };

        "stephen@wsl" = lib.homeManagerConfiguration {
	        modules = [ ./home/stephen/wsl.nix ];
	        pkgs = pkgsFor.x86_64-linux;
	        extraSpecialArgs = { inherit inputs outputs; };
        };

        "stephen@nixvm" = lib.homeManagerConfiguration {
	        modules = [ ./home/stephen/nixvm.nix ];
	        pkgs = pkgsFor.x86_64-linux;
	        extraSpecialArgs = { inherit inputs outputs; };
        };
      };
    };
}
