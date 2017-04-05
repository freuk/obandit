with import <nixpkgs> {};
let
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);
  #ocamlCallPackage = pkgs.ocamlPackages.callPackageWith (pkgs // pkgs.xlibs // self);
  self = rec {
    obandit = pkgs.ocamlPackages.callPackage ./obandit.nix { };
  };
in
  self
