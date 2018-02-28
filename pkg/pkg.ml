#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe
    ~distrib:(Pkg.distrib ()) "obandit"
  @@ fun c ->
    Ok [ Pkg.mllib "src/obandit.mllib";
         Pkg.bin "src-bin/cli" ~dst:"obandit";
       ]
