{
  pkgs ? import ( fetchTarball "https://github.com/NixOS/nixpkgs/archive/17.09.tar.gz") {},
}:
let
  self = rec {
    obandit_orig = pkgs.ocamlPackages.callPackage ./obandit.nix {};
    obandit = obandit_orig.overrideAttrs (oldAttrs : { src = ./.; });
    zymake = (import ./zymake {inherit pkgs;}).zymake;

    commit_id = pkgs.runCommand "hash"
    { nativeBuildInputs = [ pkgs.git ]; preferLocalBuild = true; } ''
    mkdir $out
    git -C ${./.} rev-parse HEAD > $out/hash
    '';

    validation = pkgs.callPackage ./validation {
      inherit zymake obandit;
      obanditcommit=builtins.readFile "${commit_id}/hash";
      rstudioWrapper=pkgs.rstudioWrapper.overrideAttrs (oldAttrs : {
        propagatedBuildInputs = with pkgs;[ qt5.full qt5.qtwebkit qt5.qtwebchannel ];
      });
    };

  };
in
  self
