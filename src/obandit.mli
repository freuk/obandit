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
  (**This module parameter gives the exploration rate and number of actions of the bandit.*)
  val n : int
  (**Number of actions*)
  val explo : float
(**Exploration rate.*)
end

module type Bandit = sig
  (**A Mutable bandit.*)
  val getAction : float -> int
(**Give the positive reward for the last action and choose the next action, encoded as
  an integer in the [0,n-1] range for n actions.
  Rewards should be between 0 and 1. For rewards larger than 1, use the WrapDoubling functor.
  The first reward is discarded.*)
end

module MakeExp3 (P : BanditParam) : Bandit
(**Exp3 Bandit.*)

module MakeUCB1 (P : BanditParam) : Bandit
(**UCB1 Bandit.*)

module MakeEpsilonGreedy (P : BanditParam) : Bandit
(**Epsilon-Greedy Bandit with a fixed exploration rate.*)

module WrapDoubling (B : Bandit) : Bandit
(**This functor wraps a bandit algorithm with the
  doubling trick. This means that all rewards are rescaled according to a scale
  (initially, 1). When a value is observed above the scale, the bandit
  algorithm is restarted and the scale is doubled.  This is useful when reward
  scale is unknown and larger than 1.*)
