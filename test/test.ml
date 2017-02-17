(*---------------------------------------------------------------------------
   Copyright (c) 2017 Valentin Reis. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
   %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

(*---------------------------------------------------------------------------
   Copyright (c) 2017 Valentin Reis

   Permission to use, copy, modify, and/or distribute this software for any
   purpose with or without fee is hereby granted, provided that the above
   copyright notice and this permission notice appear in all copies.

   THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
   WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
   MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
   ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
   OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  ---------------------------------------------------------------------------*)

open Obandit

let doTest depth strbm=
  let str,bm = strbm
  in let module BM = (val (bm):Bandit)
  in let rsum = ref 0.
  in let a = ref 0
  in let b = ref BM.initialBandit
  in let n = ref 0
  in let getR a = if a>0 then 0.08 +. Random.float 0.08 else Random.float 0.89
  in begin
    while !n < depth do
    begin
      let newR = getR !a
      in let newA,newB = BM.step !b newR;
      in begin
        rsum := !rsum +. newR;
        n := !n + 1;
        a:=newA;
        b:=newB
      end
    end
    done;
    Printf.printf "%s: %f " str (!rsum /. (float_of_int !n));
    if (!rsum /. (float_of_int !n) > 0.37) then
      Printf.printf "converges. %s " ""
    else
      failwith "insufficient performance of the algorithm."
  end

let () =
  let module Pk = struct
    let k = 2
  end

  in let bl = [("ucb"  , (module MakeUCB1(Pk):Bandit));
               ("exp3" , (module MakeDecayingExp3(Pk):Bandit));
               ("ucbr" , (module WrapRange01(MakeUCB1(Pk)):Bandit));
               ("exp3r", (module WrapRange01(MakeDecayingExp3(Pk)):Bandit))]

  in let dtn n = List.iter (doTest n) bl; Printf.printf "%s" "\n"
  in List.iter dtn [3000;30000]
