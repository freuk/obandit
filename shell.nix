with import ./default.nix { };

mkShell {

  inputsFrom = [ obandit ];

  buildInputs = [ ocamlPackages.topkg ];

}

