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

open BatEnum

type action = int Ok | int RangeExtended

module type BanditParam = sig
  val n : int
  val rate : int -> float
end

module type Bandit = sig
  val getAction : float -> action
end

module MakeExp3 (P :BanditParam) : Bandit = struct
  let a = ref (-1)
  let w = Array.make P.n 1.
  let k = ref 1

  let wToP sum w = ((1.0 -. (P.rate !k)) *. (w /. sum)) +. ((P.rate !k) /. (float_of_int !k))

  let getAction x =
    if !a < 0 then
      let x = Random.int P.n in (a:=x; x)
      else
        let () =
          let oldSum = Array.fold_left (fun acc x -> x +. acc) 0.0 w
          in w.(!a) <- w.(!a) *. (exp ((P.rate !k) *. x /. ((float_of_int !k) *. (wToP oldSum w.(!a)))));
        in let p =
          let sum =  Array.fold_left (fun acc x -> x +. acc) 0.0 w
          in Array.map (fun w -> ((1.0 -. (P.rate !k)) *. (w /. sum)) +. ((P.rate !k) /. (float_of_int !k))) w
        in let r =
          let sump = Array.fold_left (fun acc x -> x +. acc) 0.0 p
          in Random.float sump
        in let rec sample i acc =
          if i+2=P.n then i+1
          else
            if (acc +. p.(i+1) > r) then
              i+1
            else
              sample (i+1) (acc +. p.(i+1))
        in let newA = sample (-1) 0.
        in ( a:=newA;
            k:=!k+1;
            newA)
end

let makecmp v x y = Pervasives.compare (v x) (v y)

module MakeUCB1 (P : BanditParam) : Bandit = struct
  let a = ref (-1)
  let u = Array.make P.n 0.
  let nVisits = Array.make P.n 0
  let k = ref 0

  let f i = (u.(i) /. float_of_int (nVisits.(i))) +. ((P.rate !k) *. log (float_of_int (!k+1)) /. (float_of_int nVisits.(i)))

  let getAction x =
    let newA = if !k < P.n
    then
      begin
        (if !a > -1 then u.(!k) <- x else ());
        !k
      end
    else
      begin
        u.(!a) <- u.(!a) +. x;
        snd (BatList.min_max ~cmp:(makecmp f) (BatList.of_enum (0 -- (P.n-1))))
      end
    in (nVisits.(newA) <- nVisits.(newA) + 1;
        a := newA;
        k := !k+1;
        newA)
end


module MakeEpsilonGreedy (P : BanditParam) : Bandit = struct
  let a = ref (-1)
  let u = Array.make P.n 0.
  let nVisits = Array.make P.n 0
  let k = ref 0

  let f i = u.(i) /. float_of_int (nVisits.(i))

  let getAction x =
    let newA = if !k < P.n
    then
      begin
        (if !a > -1 then u.(!k) <- x else ());
        !k
      end
    else
      begin
        u.(!a) <- u.(!a) +. x;
        if Random.float 1. < (P.rate !k) then
          snd (BatList.min_max ~cmp:(makecmp f) (BatList.of_enum (0 -- (P.n-1))))
        else
          Random.int P.n
      end
    in (nVisits.(newA) <- nVisits.(newA) + 1;
        a := newA;
        k := !k+1;
        newA)
end

module type RangeParam = sig
  val upper : float
  val lower : float
end

module WrapRange (R:RangeParam) (P:BanditParam) (B : functor (Pb:BanditParam) -> Bandit) : Bandit = struct
  let makeM () = (module B(P) : Bandit)
  let m = ref (makeM ())

  let u = ref R.upper
  let l = ref R.lower

  let getAction x =
      if x > !u then (u := !l +. ((!u -. !l) *. 2.0); m := makeM ());
      if x < !l then (l := !u -. ((!u -. !l )*. 2.0); m := makeM ());
      let module M = (val (!m))
      in M.getAction ((x -. !l) /. (!u -. !l))
end

module WrapRange01 = WrapRange(struct let upper=1. let lower=0. end)
