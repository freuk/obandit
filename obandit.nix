{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, ocaml_batteries, topkg }:

stdenv.mkDerivation rec {
	name = "obandit-${version}";
	version = "0.2.1";
	src = fetchurl {
		url = "https://github.com/freuk/obandit/archive/v0.2.1-zenodo.tar.gz";
		sha256 = "1a8l4kvv811vy11gjj9nvz1px7s4zxrr3zi53zblvkibq56zzl7s";
	};

	unpackCmd = "tar xjf $src";

	buildInputs = [ ocaml findlib ocamlbuild topkg opam ];

  propagatedBuildInputs = [ ocaml_batteries ];

	inherit (topkg) buildPhase installPhase;

	meta = {
		license = stdenv.lib.licenses.isc;
		homepage = https://github.com/freuk/obandit;
		description = "OCaml module for multi-armed bandits";
		inherit (ocaml.meta) platforms;
	};
}
