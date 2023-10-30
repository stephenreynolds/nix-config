{ lib, inputs, ... }:
let
  inherit (lib.my) mapModulesRec';
  inherit (lib.modules) mkAliasOptionModule;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (mkAliasOptionModule [ "hm" ] [ "home-manager" ])
  ] ++ (mapModulesRec' (toString ./modules) import);

  system = { stateVersion = "23.11"; };
}
