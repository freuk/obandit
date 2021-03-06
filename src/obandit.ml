(*---------------------------------------------------------------------------
  Copyright (c) 2017 Valentin Reis. All rights reserved.
  Distributed under the ISC license, see terms at the end of the file.
  %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

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

(***************************Utilities*****************************)

(* Makes a comparator function.*)
let makecmp v x y = Pervasives.compare (v x) (v y)

(* Gets the argmax of a function on a list.*)
let argmax f l = snd (BatList.min_max ~cmp:(makecmp f) l)

(* argmax of the list [0,..,k-1] according to criteria f. *)
let getA k f = argmax f (BatList.range 0 `To (k-1))

(* Increments a list at position i, return a new list.*)
let incList i l = BatList.modify_at i (fun x->x+1) l

(* Sample an integer from a probability distribution.*)
let sample p =
  let r = Random.float (BatList.fsum p)
  in let rec sample i acc = function
    |p::ps -> let ap = acc +. p
        in if (r <= ap) then i+1 else sample (i+1) ap ps
    |[] -> i
  in sample (-1) 0. p

(**************************** UCB *******************************)

module MakeAlphaPhiUCB (P:AlphaPhiUCBParam) : Bandit with type bandit = banditEstimates =
struct
  type bandit = banditEstimates
  let initialBandit = initialBanditEstimates P.k
  let f (b:banditEstimates) i =
    let ti = float_of_int (List.nth b.nVisits i)
    and t = float_of_int b.t
    in (List.nth b.u i /. ti) +. P.invLFPhi (P.alpha *. (log t) /. ti)
  let step (b:banditEstimates) x =
    let a = if b.t < P.k then b.t else getA P.k (f b)
    in a,
       {t = b.t+1;
        a = a;
        nVisits = if b.a>=0 then incList b.a b.nVisits else b.nVisits;
        u = if b.a>=0 then BatList.modify_at b.a (fun ui -> ui +. x) b.u else b.u}
end

module MakeAlphaUCB (P : AlphaUCBParam) : Bandit with type bandit = banditEstimates =
  MakeAlphaPhiUCB(struct
    include P
    let invLFPhi x = sqrt (x /. 2.)
  end)

module MakeUCB1 (P : KBanditParam) : Bandit with type bandit = banditEstimates =
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
        Random.int P.k
      else
        getA P.k (f b)
    in a,
       {t=b.t+1;
        a=a;
        nVisits = if b.a>=0 then incList b.a b.nVisits else b.nVisits;
        u = if b.a>=0 then BatList.modify_at b.a (fun ui -> ui +. x) b.u else b.u}
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

(* initial a=-1 t=1 w=array of 1s*)
module MakeExp3 (P : RateBanditParam) : Bandit with type bandit = banditPolicy =
struct
  type bandit = banditPolicy
  let initialBandit = initialBanditPolicy P.k

  let wToP wsum t wi =
    let eta = P.rate t
    in ((1.0 -. eta) *. wi /. wsum) +. (eta /. float_of_int P.k)

  let step b x =
    let a,w =
      if b.a < 0
      then Random.int P.k,b.w
      else
      let f wi = wi *. (exp ((P.rate b.t) *. x /. ((float_of_int P.k) *. (wToP (BatList.fsum b.w) b.t wi))))
      in let w = BatList.modify_at b.a f b.w;
      in let p = List.map (wToP (BatList.fsum w) b.t) w
      in (sample p,w)
    in a,
       {t = b.t+1;
        a = a;
        w = w}
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

type 'b rangedBandit = {bandit:'b;
                        u:float;
                        l:float}

type rangedAction = Reset of int | Action of int

module type RangedBandit = sig
  type bandit
  val initialBandit : bandit rangedBandit
  val step : bandit rangedBandit -> float -> rangedAction * (bandit rangedBandit)
end

module WrapRange (R:RangeParam) (B:Bandit) : RangedBandit with type bandit = B.bandit = struct
  type bandit = B.bandit
  let initialBandit = {bandit=B.initialBandit;
                       u=R.upper;
                       l=R.lower}
  let step b x =
    if x>b.u then
      let u' = b.l +. ((x -. b.l) *. 2.0)
      in let a,b' = B.step B.initialBandit ((x -. b.l) /. (u' -. b.l))
      in (Reset a,{b with bandit=b'; u=u'})
    else if x<b.l then
      let l' = b.u -. ((b.u -. x) *. 2.0)
      in let a,b' = B.step B.initialBandit ((x -. l') /. (b.u -. l'))
      in (Reset a,{b with bandit=b'; l=l'})
    else
    let a,b' = B.step b.bandit  ((x -. b.l) /. (b.u -. b.l))
    in (Action a,{b with bandit=b'})
end

module WrapRange01 (B:Bandit) : RangedBandit with type bandit = B.bandit =
  WrapRange(struct let upper=1. let lower=0. end)(B)
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
