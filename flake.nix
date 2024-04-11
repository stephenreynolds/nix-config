{
  description = "My Nix configuration";

  nixConfig = {
    extra-substituters =
      [ "https://hyprland.cachix.org" "https://nix-gaming.cachix.org" ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-onebar = {
      url = "git+https://codeberg.org/Freeplay/Firefox-Onebar";
      flake = false;
    };

    desktop-flake = {
      url = "github:stephenreynolds/desktop-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      url = "github:stephenreynolds/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      inherit (self) outputs;
      inherit (lib.my) mapModules mapModulesRec mapHosts;
      system = "x86_64-linux";

      mkPkgs = pkgs: extraOverlays:
        import pkgs {
          inherit system;
          config.allowUnfree = true;
          # TODO: remove after https://nixpk.gs/pr-tracker.html?pr=302544 gets merged
          config.packageOverrides = pkgs: {
            electron_28 = pkgs.electron_28.overrideAttrs
              (oldAttrs: {

                buildCommand =
                  let
                    electron-unwrapped = pkgs.electron_28.passthru.unwrapped.overrideAttrs (oldAttrs: {
                      postPatch = builtins.replaceStrings [ "--exclude='src/third_party/blink/web_tests/*'" ] [ "--exclude='src/third_party/blink/web_tests/*' --exclude='src/content/test/data/*'" ] oldAttrs.postPatch;
                    });
                  in
                  ''
                    gappsWrapperArgsHook
                    mkdir -p $out/bin
                    makeWrapper "${electron-unwrapped}/libexec/electron/electron" "$out/bin/electron" \
                      "''${gappsWrapperArgs[@]}" \
                      --set CHROME_DEVEL_SANDBOX $out/libexec/electron/chrome-sandbox

                    ln -s ${electron-unwrapped}/libexec $out/libexec
                  '';
              });
            electron = pkgs.electron.overrideAttrs
              (oldAttrs: {
                buildCommand =
                  let
                    electron-unwrapped = pkgs.electron.passthru.unwrapped.overrideAttrs (oldAttrs: {
                      postPatch = builtins.replaceStrings [ "--exclude='src/third_party/blink/web_tests/*'" ] [ "--exclude='src/third_party/blink/web_tests/*' --exclude='src/content/test/data/*'" ] oldAttrs.postPatch;
                    });
                  in
                  ''
                    gappsWrapperArgsHook
                    mkdir -p $out/bin
                    makeWrapper "${electron-unwrapped}/libexec/electron/electron" "$out/bin/electron" \
                      "''${gappsWrapperArgs[@]}" \
                      --set CHROME_DEVEL_SANDBOX $out/libexec/electron/chrome-sandbox

                    ln -s ${electron-unwrapped}/libexec $out/libexec
                  '';
              });
          };
          overlays = extraOverlays ++ (builtins.attrValues self.overlays);
        };
      pkgs = mkPkgs nixpkgs [ self.overlays.default ];

      lib = nixpkgs.lib.extend (final: prev: {
        my = import ./lib {
          inherit pkgs inputs outputs;
          lib = final;
        };
      });
    in
    {
      overlays = (mapModules ./overlays import) // {
        default = final: prev: { my = self.packages.${system}; };
      };

      packages."${system}" = mapModules ./pkgs (p: pkgs.callPackage p { });

      templates = lib.pipe ./templates [
        builtins.readDir
        (builtins.mapAttrs (name: _: {
          description = name;
          path = ./templates/${name};
        }))
      ];

      nixosModules = { flake = import ./.; } // mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };

      devShells."${system}".default = import ./shell.nix { inherit pkgs; };

      formatter."${system}" = pkgs.nixfmt;

      checks."${system}" =
        let
          inherit (lib) getExe;
          mkCheck = linter:
            pkgs.runCommand "lint" { } ''
              cd ${self}
              ${linter} 2>&1
              touch $out
            '';
        in
        { statix = mkCheck "${getExe pkgs.statix} check ${self}"; };
    };
}
