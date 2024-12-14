{ lib, inputs, config, ... }:

let
  inherit (lib.my) mapModulesRec';
  inherit (lib.modules) mkAliasOptionModule;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (mkAliasOptionModule [ "hm" ] [ "home-manager" "users" config.user.name ])
  ] ++ (mapModulesRec' (toString ./modules) import);

  system = { stateVersion = "23.11"; };
}
