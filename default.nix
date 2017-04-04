{pkgs ? import <nixpkgs> {} }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);
  #ocamlCallPackage = pkgs.ocamlPackages.callPackageWith (pkgs // pkgs.xlibs // self);
  self = rec {
    obandit = pkgs.ocamlPackages.callPackage ./obandit.nix { };
    dev = pkgs.stdenv.mkDerivation {
    name = "baseOcaml";
    buildInputs =
    [ pkgs.bzip2
    pkgs.gmp
    (pkgs.texlive.combine {
    inherit (pkgs.texlive) cases scheme-small;
    })
  ];
    TOPKG_DELEGATE=''./ocaml_delegate.ml'';
    #shellHook = '' export PS1="topkg-prompt> " '';
  };
  };
in
  self
