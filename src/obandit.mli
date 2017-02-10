(*---------------------------------------------------------------------------
   Copyright (c) 2017 Valentin Reis. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
   %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

(** Ocaml Multi-Armed Bandits

    {e %%VERSION%% — {{:%%PKG_HOMEPAGE%% }homepage}} *)

(** {1 Obandit} *)

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

module type BanditParam = sig
  (**The BanditParam module parameter gives the exploration rate and number of actions of the bandit.*)
  val n : int
  (**Number of actions*)
  val rate : int -> float
  (**Exploration/learning rate, fixed or decaying. takes the round number as argument
   and returns the value of the learning rate*)
end

module type Bandit = sig
  (**A Mutable bandit.*)
  val getAction : float -> int
  (**The getAction function mutates the bandit one step further in the bandit game. 
  The argument is the reward for the last action and the result is the next action.
  Rewards are floats in [0,1] and actions are integers in [0,n-1].
  The first reward is discarded. In order to use rewards larger than 1, please use
  the WrapDoubling functor.*)
end

module MakeExp3 (P : BanditParam) : Bandit
(**The Exp3 Bandit for adversarial regret minimization.*)

module MakeUCB1 (P : BanditParam) : Bandit
(**The UCB1 Bandit for stochastic regret minimization .*)

module MakeEpsilonGreedy (P : BanditParam) : Bandit
(**The Epsilon-Greedy Bandit with a fixed exploration rate.*)

module type RangeParam = sig
  val upper : float
  (**The upper value of the range*)
  val lower : float
  (**The lower value of the range*)
end

module WrapRange (R:RangeParam) (P:BanditParam) (B : functor (Pb:BanditParam) -> Bandit) : Bandit
  (**The WrapRange functor wraps a bandit algorithm with the doubling trick.
  This heuristic allows to use a andit algorithm without knowing the reward
  ranges. All rewards are linearly rescaled to a range (initially given by a RangeParam).
  When a value is observed above the range, the bandit algorithm is restarted 
  and the range interval is doubled in that direction.
  *)

module WrapRange01 (P:BanditParam) (B : functor (Pb:BanditParam) -> Bandit) : Bandit
  (**The WrapRange01 functor is a convenience aliasing of WrapRange with an
   initial "standard" range of [0,1].
  *)
