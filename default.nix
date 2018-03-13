{
  pkgs ? import ( fetchTarball "https://github.com/NixOS/nixpkgs/archive/17.09.tar.gz") {},
}:
let
  self = rec {
    obandit_orig = pkgs.ocamlPackages.callPackage ./obandit.nix {};

    #commit_id_hash = pkgs.runCommand "hash"
    #{ nativeBuildInputs = [ pkgs.git ]; preferLocalBuild = true; } ''
      #mkdir $out
      #git -C ${./.} rev-parse HEAD > $out/hash
    #'';
    #commit=builtins.readFile "${commit_id_hash}/hash";

    obandit = obandit_orig.overrideAttrs (oldAttrs : {
      src = ./.;
      version = "git";
    });
    zymake = (import ./zymake {inherit pkgs;}).zymake;

    validation = obandit: pkgs.callPackage ./validation {
      inherit zymake obandit;
      obanditversion=obandit.version;
      rstudioWrapper=pkgs.rstudioWrapper.overrideAttrs (oldAttrs : {
        propagatedBuildInputs = with pkgs;[ qt5.full qt5.qtwebkit qt5.qtwebchannel ];
      });
    };

    validation-local = validation obandit;

    web = obandit: pkgs.callPackage ./web {
      inherit obandit;
      validation = validation obandit;
    };

    web-local = web obandit;

  };
in
  self
