#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "obandit" @@ fun c ->
  Ok [ Pkg.mllib "src/obandit.mllib";
       Pkg.test "test/test"; ]
