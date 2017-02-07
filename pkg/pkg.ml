#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe 
    ~distrib:(Pkg.distrib ~uri:"http://freux.fr/obandit/distrib/" ()) "obandit" 
  @@ fun c ->
  Ok [ Pkg.mllib "src/obandit.mllib";
       Pkg.test "test/test"; ]
