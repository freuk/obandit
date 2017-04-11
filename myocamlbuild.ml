open Ocamlbuild_plugin

let () = flag ["doc";"ocaml"] & S[A"-i";A"-g _build/doc_custom.cma"];
