{ src ? ../.

, nixpkgs ? <nixpkgs>

, pkgs ? import ./nixpkgs.nix {
  inherit nixpkgs;
  inherit src;
} }: {
  obandit = pkgs.ocamlPackages.callPackage ./obandit { };
}
