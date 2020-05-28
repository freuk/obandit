{ pkgs ? import (builtins.fetchTarball
  "https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz") { } }:

pkgs // {

  obandit = pkgs.ocamlPackages.callPackage ./obandit.nix { };

}

