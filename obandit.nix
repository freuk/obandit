{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, ocamlPackages, topkg }:

stdenv.mkDerivation rec {
	name = "obandit-${version}";
	version = "0.2.1";

	src = fetchurl {
		url = "https://github.com/freuk/obandit/archive/v${version}-zenodo.tar.gz";
		sha256 = "1a8l4kvv811vy11gjj9nvz1px7s4zxrr3zi53zblvkibq56zzl7s";
	};
	#unpackCmd = "tar xjf $src";

  buildInputs = [ ocaml findlib ocamlbuild topkg opam
  ocamlPackages.ocaml_batteries
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
