{
  pkgs ? import ( fetchTarball "https://github.com/NixOS/nixpkgs/archive/17.09.tar.gz") {},
}:
let
  latest = pkgs.ocamlPackages.callPackage ./obandit.nix {};
  local = latest.overrideAttrs (oldAttrs : {
    src = ./.;
    version = "git";
  });
  zymake = (import ./zymake {inherit pkgs;}).zymake;
  makeSet = obandit: {
    inherit obandit;
    validation = pkgs.callPackage ./validation {
      inherit zymake obandit;
      rstudioWrapper=pkgs.rstudioWrapper.overrideAttrs (oldAttrs : {
        propagatedBuildInputs = with pkgs;[ qt5.full qt5.qtwebkit qt5.qtwebchannel ];
      });
    };
    web = pkgs.callPackage ./web { inherit obandit; };
  };
in {
  local = makeSet local;
  latest = makeSet latest;
}
