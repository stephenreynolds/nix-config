{ inputs, outputs, lib, pkgs, ... }:
let
  inherit (modules) mapModules;

  modules = import ./modules.nix {
    inherit lib;
    self.attrs = import ./attrs.nix {
      inherit lib;
    };
  };

  mylib = lib.makeExtensible (self:
    mapModules ./. (file: import file { inherit self lib pkgs inputs outputs; }));
in
mylib.extend (self: super: lib.foldr (a: b: a // b) { } (builtins.attrValues super))
