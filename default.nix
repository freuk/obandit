{
  pkgs ? import ( fetchTarball "https://github.com/NixOS/nixpkgs/archive/17.09.tar.gz") {},
}:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);
  #ocamlCallPackage = pkgs.ocamlPackages.callPackageWith (pkgs // pkgs.xlibs // self);
  self = rec {
    obandit_orig = pkgs.ocamlPackages.callPackage ./obandit.nix {};
    obandit = obandit_orig.overrideAttrs (oldAttrs : { src = ./.;});
  };
in
  self
