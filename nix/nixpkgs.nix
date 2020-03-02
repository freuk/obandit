{ src

, config ? { }

, overlays ? [ ]

, nixpkgs ? <nixpkgs>

, hostPkgs ? import nixpkgs { }

}:

let
  fetched = s: (hostPkgs.nix-update-source.fetch s).src;
  defaultOverlays = [
    (import ./python-overlay.nix { inherit src; })
    (import ./haskell-overlay.nix { inherit src; })
  ];
  overlaysAll = defaultOverlays ++ overlays;
in import (fetched ./pkgs.json) {
  inherit config;
  overlays = overlaysAll;
}
