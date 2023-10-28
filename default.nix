{ lib, ... }:
let inherit (lib.my) mapModulesRec';
in {
  imports = (mapModulesRec' (toString ./modules) import);

  system = { stateVersion = "23.11"; };
}
