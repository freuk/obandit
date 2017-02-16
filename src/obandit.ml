(*---------------------------------------------------------------------------
 Copyright (c) 2017 Valentin Reis. All rights reserved.
 Distributed under the ISC license, see terms at the end of the file.
 %%NAME%% %%VERSION%%
 ---------------------------------------------------------------------------*)


(* makes a comparator*)
let makecmp v x y = Pervasives.compare (v x) (v y)

(* gets the argmax of a function on a list*)
let argmax f l = snd (BatList.min_max ~cmp:(makecmp f) l)

(* gets the best of k arm according to a criteria f that uses a bandit as
 first argument*)
let getA k f = argmax f (BatList.range 0 `To (k-1))

(* increments a list at position i, return a new list*)
let incList i l = BatList.modify_at i (fun x->x+1) l

module type Bandit = sig
  type bandit
  val initialBandit : bandit
  val step : bandit -> float -> int * bandit
end

type banditEstimates = {t:int;
                        a:int;
                        nVisits:int list;
                        u:float list}
let initialBanditEstimates k = {t       = 0;
                              a       = -1;
                              nVisits = BatList.make k 0;
                              u       = BatList.make k 0.}
type banditPolicy = {t:int;
                     a:int;
                     w:float list}
let initialBanditPolicy k = {t = 1;
                           a = -1;
                           w = BatList.make k 1.}

module type AlphaPhiUCBParam = sig
  val k : int
  val alpha : float
  val invLFPhi: float -> float
end

module type AlphaUCBParam = sig
  val k : int
  val alpha : float
end

module type KBanditParam = sig
  val k : int
end

module type RateBanditParam = sig
  val k : int
  val rate : int -> float
end

module type DecayingEpsilonGreedyParam = sig
  val k : int
  val c : float
  val d : float
end

module type EpsilonGreedyParam = sig
  val k : int
  val epsilon : float
end

module type FixedExp3Param = sig
  val k : int
  val eta : float
end

module type HorizonExp3Param = sig
  val k : int
  val n : int
end

module type RangeParam = sig
  val upper : float
  val lower : float
end

(**************************** UCB *******************************)

module MakeAlphaPhiUCB (P:AlphaPhiUCBParam) : Bandit with type bandit = banditEstimates =
struct
  type bandit = banditEstimates
  let initialBandit = initialBanditEstimates P.k
  let f (b:banditEstimates) i = (List.nth b.u i /. float_of_int (List.nth b.nVisits i)) +.
              P.invLFPhi (P.alpha *. log (float_of_int b.t) /. (float_of_int (List.nth b.nVisits i)))
  let step (b:banditEstimates) x =
    let a = if b.t < P.k then b.t else getA P.k (f b)
    in (a,
        {t = b.t+1;
         a = a;
         nVisits = incList a b.nVisits;
         u = BatList.modify_at a (fun ui -> ui +. x) b.u})
end

module MakeAlphaUCB (P : AlphaUCBParam) : Bandit with type bandit = banditEstimates =
  MakeAlphaPhiUCB(struct
                    include P
                    let invLFPhi x = sqrt (x /. 2.)
                  end)

module MakeUCB1 (P : AlphaUCBParam) : Bandit with type bandit = banditEstimates =
  MakeAlphaUCB(struct
                 include P
                 let alpha=4.
               end)

(**************************** EPSILON GREEDY *******************************)

module MakeParametrizableEpsilonGreedy (P : RateBanditParam) : Bandit with type bandit = banditEstimates =
struct
  type bandit = banditEstimates
  let initialBandit = initialBanditEstimates P.k

  let f b i = (List.nth b.u i /. float_of_int (List.nth b.nVisits i))

  let step (b:banditEstimates) x =
    let a = if b.t < P.k
    then b.t
    else if Random.float 1. < (P.rate b.t) then
      getA P.k (f b)
    else
      Random.int P.k
    in (a,
       {t=b.t+1;
        a=a;
        nVisits = incList a b.nVisits;
        u = BatList.modify_at a (fun ui -> ui +. x) b.u})
end

module MakeDecayingEpsilonGreedy (P : DecayingEpsilonGreedyParam) : Bandit with type bandit = banditEstimates  =
  MakeParametrizableEpsilonGreedy(struct
                                    include P
                                    let rate t = min 1. ((c *. (float_of_int P.k)) /.( P.d *. P.d *. float_of_int t))
                                  end)

module MakeEpsilonGreedy (P : EpsilonGreedyParam) : Bandit with type bandit = banditEstimates =
  MakeParametrizableEpsilonGreedy(struct
                                    include P
                                    let rate _ = P.epsilon
                                  end)

(********************************* EXP3 **********************************)

module MakeExp3 (P : RateBanditParam) : Bandit with type bandit = banditPolicy =
struct
  type bandit = banditPolicy
  let initialBandit = initialBanditPolicy P.k

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
        in let f wi = wi *. (exp ((P.rate b.t) *. x /. ((float_of_int b.t) *. (wToP b sum wi))))
        in let w = BatList.modify_at b.a f b.w;
        in let p =
          let sum = BatList.fsum w
          in let f wi =
            ((1.0 -. (P.rate b.t)) *. (wi /. sum)) +. ((P.rate b.t) /. (float_of_int b.t))
          in List.map f w
        in let r =
          let sump = BatList.fsum p
          in Random.float sump
        in let rec sample i acc =
          if i+2=P.k then i+1
          else
            if (acc +. (List.nth p (i+1)) > r) then
              i+1
            else
              sample (i+1) (acc +. List.nth p (i+1))
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
             let rate t = sqrt ( log (float_of_int P.k) /. (float_of_int (t * P.k)))
           end)

module MakeFixedExp3 (P : FixedExp3Param) : Bandit with type bandit = banditPolicy =
  MakeExp3(struct
             include P
             let rate _ = P.eta
           end)

module MakeHorizonExp3 (P : HorizonExp3Param) : Bandit with type bandit = banditPolicy =
  MakeExp3(struct
             include P
             let rate _ = sqrt (2. *. (log (float_of_int P.k)) /. (float_of_int (P.n * P.k)))
           end)

(*******************************DOUBLING TRICK*************************)
(*module WrapRange (R:RangeParam) (P:BanditParam) (B : functor (Pb:BanditParam) -> Bandit) : Bandit = struct*)
  (*let makeM () = (module B(P) : Bandit)*)
  (*let m = ref (makeM ())*)

  (*let u = ref R.upper*)
  (*let l = ref R.lower*)

  (*let getAction x =*)
    (*if x > !u then (u := !l +. ((!u -. !l) *. 2.0); m := makeM ());*)
    (*if x < !l then (l := !u -. ((!u -. !l )*. 2.0); m := makeM ());*)
    (*let module M = (val (!m))*)
    (*in M.getAction ((x -. !l) /. (!u -. !l))*)
(*end*)

(*module WrapRange01 = WrapRange(struct let upper=1. let lower=0. end)*)

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
