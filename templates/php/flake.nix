{
  description = "PHP project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      phpVersion = 83;
      overlays = [
        (final: prev: {
          php = prev."php${toString phpVersion}".buildEnv {
            extensions = ({ enabled, all }: enabled ++ (with all; [
              xdebug
            ]));
            extraConfig = ''
            '';
          };
        })
      ];

      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSystem = f:
        nixpkgs.lib.genAttrs supportedSystems
          (system: f { pkgs = import nixpkgs { inherit overlays system; }; });
    in
    {
      devShells = forEachSystem ({ pkgs }: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            php
            php.packages.composer
            nodejs
          ];

          shellHook = ''
            export PATH=$HOME/.config/composer/vendor/bin:$PATH
            export XDEBUG_MODE=coverage
          '';
        };
      });
    };
}
