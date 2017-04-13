#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.distrib ~uri:"https://github.com/freux/obandit" ();
  Pkg.describe 
    ~distrib:(Pkg.distrib ()) "obandit" 
  @@ fun c ->
  Ok [ Pkg.mllib "src/obandit.mllib";
       Pkg.test "test/test"; 
  ]
