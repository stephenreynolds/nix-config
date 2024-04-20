{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = { systems, nixpkgs, ... }:
    let
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (
        system:
        f nixpkgs.legacyPackages.${system}
      );
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs.nodePackages_latest; [
            nodejs
            pnpm
            typescript
            typescript-language-server
          ];
        };
      });
    };
}
