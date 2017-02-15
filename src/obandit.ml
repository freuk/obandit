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

let makecmp v x y = Pervasives.compare (v x) (v y)

let argmax f l = snd (BatList.min_max ~cmp:(makecmp f))

module type Bandit = sig
  type bandit
  val initialBandit : bandit
  val step : bandit -> float -> int * bandit
end

type banditEstimates = {t:int; a:int; nVisits:int array;u:float array}

module type AlphaPhiUCBParam = sig
  val k : int
  val alpha : float
  val invLFPhi: float
end


module MakeAlphaPhiUCB (P : AlphaPhiUCBParam) : Bandit with type bandit = banditEstimates = struct

  let f b i = (List.nth b.u i /. float_of_int (List.nth b.nVisits i)) +.
                ((P.rate b.t) *. sqrt ( 2. *. log (float_of_int (b.t+1)) /. (float_of_int (List.nth b.nVisits i))) )
                                                                       
  let getA b = argmax (f b) (BatList.of_enum (0 -- (P.n-1))))

  let step b x =
    let a = if b.t < P.k
    then b.t
    else argmax b
    in
      (a,
       {t = b.t+1;
        a = a;
        nVisits = BatList.modify_at a (fun x -> x + 1) b.nVisits;
        u = BatList.modify_at a (fun x -> x) b.u})
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


module MakeUCB1 (P : BanditParam) : Bandit = struct
  let a = ref (-1)
  let u = Array.make P.n 0.
  let nVisits = Array.make P.n 0
  let k = ref 0

  let f i = (u.(i) /. float_of_int (nVisits.(i))) +. ((P.rate !k) *. sqrt ( 2. *. log (float_of_int (!k+1)) /. (float_of_int nVisits.(i))) )

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
