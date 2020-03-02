{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, opam, ocamlPackages, topkg }:

stdenv.mkDerivation rec {
	name = "obandit-${version}";
	version = "0.3.4";

  src = fetchzip {
    url = "https://github.com/freuk/obandit/archive/v${version}.tar.gz";
    sha256 = "0jzfn6jgmflcfinw4izlwjmahm3g49an7yn0675f7f2zvgchl0nr";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg opam
  ocamlPackages.batteries
  ocamlPackages.cmdliner
  ];

  inherit (topkg) buildPhase;

  patchPhase=''
    substituteInPlace src/obandit.mli --replace %%VERSION%% ${version}
  '';

  installPhase = ''
    opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR
    mkdir -p $out/doc
    ${ocaml}/bin/ocamlc -I +ocamldoc -c doc/plugin.ml
    cp doc/style.css $out/doc
    echo "running : ${ocaml}/bin/ocamldoc -html -g doc/plugin.cmo -d $out/doc src/obandit.mli"
    ${ocaml}/bin/ocamldoc -g doc/plugin.cmo -d $out/doc src/obandit.mli
  '';

	meta = {
		license = stdenv.lib.licenses.isc;
		homepage = https://github.com/freuk/obandit;
		description = "OCaml module for multi-armed bandits";
		inherit (ocaml.meta) platforms;
	};
}
