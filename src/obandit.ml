(*---------------------------------------------------------------------------
 Copyright (c) 2017 Valentin Reis. All rights reserved.
 Distributed under the ISC license, see terms at the end of the file.
 %%NAME%% %%VERSION%%
 ---------------------------------------------------------------------------*)
open BatList

(*makes a comparator*)
let makecmp v x y = Pervasives.compare (v x) (v y)

(*gets the argmax of a function on a list*)
let argmax f l = snd (BatList.min_max ~cmp:(makecmp f))

(* gets the best of k arm according to a criteria f that uses a bandit as
 first argument*)
let getA k b f = argmax (f b) (BatList.range 0 `To (b.k-1))

module type Bandit = sig
  type bandit
  val initialBandit : bandit
  val step : bandit -> float -> int * bandit
end

type banditEstimates = {t:int;
                        a:int;
                        nVisits:int list;
                        u:float list}
let initialBanditEstimates = {t       = 0;
                              a       = -1;
                              nVisits = BatList.make k 0;
                              u       = BatList.make k 0.}
type banditPolicy = {t:int;
                     a:int;
                     w:float array}
let initialBanditPolicy = {t = 1;
                           a = -1;
                           w = BatList.make k 1.}

module type AlphaPhiUCBParam = sig
  val k : int
  val alpha : float
  val invLFPhi: float
end

module type AlphaUCBParam = sig
  val k : int
  val alpha : float
end

module type KBanditParam = sig
  val k : int
end

module MakeAlphaPhiUCB (P : AlphaPhiUCBParam) : Bandit with type bandit = banditEstimates =
struct
  type bandit = banditEstimates
  let initialBandit = initialBanditEstimates
  let f b i = (List.nth b.u i /. float_of_int (List.nth b.nVisits i)) +.
              P.invLFPhi (P.alpha *. ln b.t /. (List.nth b.nVisits i))
  let step b x =
    let a = if b.t < P.k then b.t else getA P.k b f
    in (a,
        {t = b.t+1;
         a = a;
         nVisits = BatList.modify_at a (fun x -> x + 1) b.nVisits;
         u = BatList.modify_at a (fun x -> x) b.u})
end

module MakeAlphaUCB (P : AlphaUCBParam) : Bandit with type bandit = banditEstimates =
  MakeAlphaPhiUCB(struct
                    include P
                    let invLFPhi x = sqrt (x /. 2.)
                  end)

module MakeUCB1 (P : AlphaUCBParam) : Bandit with type bandit = banditEstimates =
  MakeAlphaUcb(struct
                 include P
                 let alpha=4.
               end)

module MakeExp3 (P : RateBanditParam) : Bandit with type bandit = banditPolicy =
struct
  type bandit = banditPolicy
  let initialBandit = initialBanditPolicy
                                                                         
  let wToP b sum w = 
    ((1.0 -. (P.rate b.t)) *. (w /. sum)) +. ((P.rate b.t) /. (float_of_int b.t))

  let step b x =
    if b.a < 0 
    then
      let a = Random.int P.k 
      in (a,
          {t = b.t+1;
           a = a;
           w = b.w})
    else
        let sum = BatList.fsum b.w
        in let f wi = wi *. (exp ((P.rate !k) *. x /. ((float_of_int !k) *. (wToP b sum wi))))
        in let w = BatList.modify_at a f b.w;
        in let p = 
          let sum = BatList.fsum w
          in let f wi = 
            ((1.0 -. (P.rate b.t)) *. (w /. sum)) +. ((P.rate b.t) /. (float_of_int b.t))
          in List.map f w
        in let r =
          let sump = BatList.fsum p
          in Random.float sump
        in let rec sample i acc =
          if i+2=P.k then i+1
          else
            if (acc +. p.(i+1) > r) then
              i+1
            else
              sample (i+1) (acc +. p.(i+1))
        in let a = sample (-1) 0.
        in 
          (a,
          {t = b.t+1;
           a = a;
           w = w})
end

module MakeDecayingExp3 (P : KBanditParam) : Bandit with type bandit = banditPolicy =
  MakeExp3(struct
             include P
             let rate t = sqrt ( ln P.k /. (t *. P.k) = 
           end)

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

