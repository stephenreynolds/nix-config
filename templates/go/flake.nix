{
  description = "Go project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      lastModifiedDate =
        self.lastModifiedDate or self.lastModified or "19700101";

      version = builtins.substring 0 8 lastModifiedDate;

      goVersion = 22; # Change this to update the whole stack
      overlays = [ (final: prev: { go = prev."go_1_${toString goVersion}"; }) ];

      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSystem = f:
        nixpkgs.lib.genAttrs supportedSystems
          (system: f { pkgs = import nixpkgs { inherit overlays system; }; });
    in
    {
      packages = forEachSystem ({ pkgs }: {
        default = self.packages.${pkgs.system}.go-hello;
        go-hello = pkgs.buildGoModule {
          pname = "go-hello";
          inherit version;
          src = ./.;
          vendorHash = null;
        };
      });

      devShells = forEachSystem ({ pkgs }: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Go version as specified by overlay
            go
            # Language server
            gopls
            # goimports, godoc, etc.
            gotools
            # https://github.com/golangci/golangci-lint
            golangci-lint
          ];
        };
      });
    };
}
