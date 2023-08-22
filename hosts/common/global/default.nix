{ inputs, outputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./fish.nix
    ./locale.nix
    ./nix.nix
    ./systemd-initrd.nix
    ./optin-persistence.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  environment.enableAllTerminfo = true;

  hardware.enableRedistributableFirmware = true;
}
