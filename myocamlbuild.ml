open Ocamlbuild_plugin
open Ocamlbuild_pack


(* calls out to Ocaml_tools.ocamldoc_l_dir but filters out the
"extension:html"
flag which causes -html to be added to the ocamldoc command line.*)
let my_ocamldoc tags deps docout docdir =
let tags = tags -- "extension:html" in
Ocaml_tools.ocamldoc_l_dir tags deps docout docdir

(* copy of the normal ocamldoc rule that uses our custom generator. *)
let () = Rule.rule
"ocamldoc: document ocaml project odocl & *odoc -> docdir (html+)"
~insert:`top
~prod:"%.docdir/index.html"
~stamp:"%.docdir/html.stamp"
~dep:"%.odocl"
(Ocaml_tools.document_ocaml_project
~ocamldoc:my_ocamldoc
"%.odocl" "%.docdir/index.html" "%.docdir");

dep ["doc";"ocaml";"intro"] ["lib/intro.txt"];
flag ["doc";"ocaml"] & S[A"-i";A"-g";A"_build/odoc_custom.cma"];
flag ["doc";"ocaml";"intro"] & S[A"-intro";A"lib/intro.txt"]
