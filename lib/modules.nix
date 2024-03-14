{ lib, self, ... }:

rec {
  mapModules = dir: fn:
    self.attrs.mapFilterAttrs (n: v: v != null && !(lib.hasPrefix "_" n)) (n: v:
      let path = "${toString dir}/${n}";
      in if v == "directory" && builtins.pathExists "${path}/default.nix" then
        lib.nameValuePair n (fn path)
      else if v == "regular" && n != "default.nix"
      && lib.hasSuffix ".nix" n then
        lib.nameValuePair (lib.removeSuffix ".nix" n) (fn path)
      else
        lib.nameValuePair "" null) (builtins.readDir dir);

  mapModules' = dir: fn: builtins.attrValues (mapModules dir fn);

  mapModulesRec = dir: fn:
    self.mapFilterAttrs (n: v: v != null && !(lib.hasPrefix "_" n)) (n: v:
      let path = "${toString dir}/${n}";
      in if v == "directory" then
        lib.nameValuePair n (mapModulesRec path fn)
      else if v == "regular" && n != "default.nix"
      && lib.hasSuffix ".nix" n then
        lib.nameValuePair (lib.removeSuffix ".nix" n) (fn path)
      else
        lib.nameValuePair "" null) (builtins.readDir dir);

  mapModulesRec' = dir: fn:
    let
      dirs = lib.mapAttrsToList (k: _: "${dir}/${k}")
        (lib.filterAttrs (n: v: v == "directory" && !(lib.hasPrefix "_" n))
          (builtins.readDir dir));
      files = builtins.attrValues (mapModules dir lib.id);
      paths = files
        ++ builtins.concatLists (map (d: mapModulesRec' d lib.id) dirs);
    in map fn paths;
}
