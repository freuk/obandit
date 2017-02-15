(*---------------------------------------------------------------------------
 Copyright (c) 2017 Valentin Reis. All rights reserved.
 Distributed under the ISC license, see terms at the end of the file.
 %%NAME%% %%VERSION%%
 ---------------------------------------------------------------------------*)

(**  Ocaml Multi-Armed Bandits

  {e %%VERSION%% — {{:%%PKG_HOMEPAGE%% }homepage}}

  {1:mutband Mutable Bandit Modules}

  This library implements multi-armed bandits as mutable modules.
  A bandit module is obtained by calling a functor with a bandit module
  parameter. The parameter gives the number of arms {m{% K %}} and
  the hyperparameters of the bandit.
  The Bandit.getAction call is used to give a reward,
  mutate the bandit game and obtain the next reward.

  *)

(** A mutable bandit.  *)
module type Bandit = sig
  val getAction : float -> int
(** getAction [r] mutates the bandit game one step, where [r] is the reward for
  the last action.  The result of this call is the next action, encoded as an
  integer in {m{% \\{ 0, \cdots , K-1 \\} %}}.  The reward range depends on the
  bandit algorithm in use and the first reward provided to the algorithm is
  discarded. *)
end

(** {1:functors Functors}

  Bandit modules are instanciated using functors. Depending on the
  algorithm type used, the module parameter varies.

  For instance, the UCB1 bandit module for 3 arms is obtained with:

  [module UCB1 =
  let module P = struct
  let k=3
  end
  in MakeUCB1(P)]

  and mutated in this manner:

  [let newAction = UCB1.getAction reward ]

  where [newAction] is the new action to be explored and [reward] is the
  reward associated with the last action that the bandit algorithm took.

  The following algorithms are available:
  *)

(**
  {2:mdf The UCB family of algorithms.}

  We use the viewpoint of the survey [[1]].

  {3:apu MakeAlphaPhiUCB: {m{% (\alpha,\psi) $-$ \text{UCB} %}}}

  At time {m{% t%}}, the {m{% (\alpha,\psi) $-$ \text{UCB} %}} algorithm[[1]] is taking action:
  {eq{%
  \text{argmax}_{i=1,\cdots,K} \left\[ \widehat{\mu_i} + (\psi^{*})^{-1} \left( \frac{\alpha \ln t}{T_i} \right) \right\]
  %}}
  where {m{% \alpha > 0 %}} is a hyperparameter, {m{% \mu_i %}} is the estimate maintained for arm i, 
  {m{% T_i%}} is the number of times arm {m{% i%}} was visited so far
  and {m{% \psi^* %}} denotes the Legendre-Fenchel transform of a convex function {m{% \psi %}}.

  At round  {m{% n%}}, this gives a pseudo-regret bound of:
  {eq{%
  \bar{R_n} \leq \sum_{i:\Delta_i > 0} \left( \frac{\alpha \Delta_i}{\psi^* (\Delta_i / 2 )} \ln n + \frac{\alpha}{\alpha-2} \right)
  %}}
  where {m{% \Delta_i = \mu^* - \mu_i %}} is the suboptimality parameter of arm {m{% i%}}.

  *)

(** Use to instanciate a [Bandit] from [MakeAlphaPhiUCB] .*)
module type AlphaPhiUCBParam = sig
  val k : int
  (** The number of actions {m{% K %}} .*)
  val alpha : float
  (** The {m{% \alpha %}} parameter.*)
  val invLFPhi: float
(** The inverse of the Legendre-Fenchel transform of {m{% \psi %}}.  *)
end


module MakeAlphaPhiUCB (P : AlphaPhiUCBParam) : Bandit
(** The {m{% (\alpha,\psi) $-$ \text{UCB} %}} Bandit for stochastic regret minimization described in [[1]]. *)


(**
  {3:apu MakeAlphaUCB: {m{% \alpha $-$ \text{UCB} %}}}

  The {m{% \alpha $-$ \text{UCB} %}} algorithm[[5]] uses {m{% \psi(\lambda) = \lambda^2 / 8 %}}.
  It chooses the action:

  {eq{%
  \text{argmax}_{i=1,\cdots,K} \left\[ \widehat{\mu_i} +  \sqrt{ \frac{\alpha \ln t}{2 T_i} } \right\]
  %}}

  At round  {m{% n%}}, this gives a pseudo-regret bound of:

  {eq{%
  \bar{R_n} \leq \sum_{i:\Delta_i > 0} \left( \frac{2 \alpha}{\Delta_i} \ln n + \frac{\alpha}{\alpha-2} \right)
  %}}

  *)


(** Use to instanciate a [Bandit] from [MakeAlphaUCB] .*)
module type AlphaUCBParam = sig
  val k : int
  (** The number of actions {m{% K %}} .*)
  val alpha : float
  (** The {m{% \alpha %}} parameter.*)
end

(** The {m{% \alpha $-$ \text{UCB} %}} Bandit for stochastic regret minimization described in [[1]] .*)
module MakeAlphaUCB (P : AlphaUCBParam) : Bandit


(**
  {3:apu MakeUCB1: {m{% \text{UCB1} %}}}

  The {m{% \text{UCB1} %}} algorithm[[5]] uses {m{% \alpha = 4 %}}.
  It chooses the action:

  {eq{%
  \text{argmax}_{i=1,\cdots,K} \left\[ \widehat{\mu_i} +  \sqrt{ \frac{2 \ln t}{T_i} } \right\]
  %}}

  At round  {m{% n%}}, this gives a pseudo-regret bound of:

  {eq{%
  \bar{R_n} \leq \sum_{i:\Delta_i > 0} \left( \frac{8}{\Delta_i} \ln n + 2 \right)
  %}}

  *)

(** Use to instanciate a [Bandit] from [MakeUCB1].*)
module type KBanditParam = sig
  val k : int
  (** The number of actions {m{% K %}} .*)
end

(** The UCB1 Bandit for stochastic regret minimization .*)
module MakeUCB1 (P: KBanditParam ) : Bandit

(**
  {2:mdf The Epsilon-Greedy family of algorithms.}

  {3:mdf MakeParametrizableEpsilonGreedy: {m{% \epsilon_n%}}-Greedy with a parametrizable rate.}

  At round {m{% t%}}, the {m{% \epsilon_t%}}-Greedy algorithm[[5]] takes action {m{% \text{argmax}_{i=1,\cdots,K} \widehat{\mu_i} %}} 
  with probability {m{% 1-\epsilon%}} and an uniformly random action with probability {m{% \epsilon_t%}}.
  *)

(** Used to instanciate algorithms that need a parametrizable exploration rate.*)
module type RateBanditParam = sig
  val k : int
  (** The number of actions {m{% K %}} .*)
  val rate : int -> float
(** The learning rate. can be fixed or decaying.  *)
end

(** The Epsilon-Greedy Bandit with a parametrizable exploration rate.*)
module MakeParametrizableEpsilonGreedy (P : RateBanditParam) : Bandit

(**
  {3:mdf MakeDecayingEpsilonGreedy: {m{% \epsilon_n%}}-Greedy with the decaying rate from [[5]].}

  This uses the exploration rate decay:
  {eq{%
   \epsilon_t = \min{\left\\{ 1, \frac{cK}{d^2 t}\right\\}}
  %}}
  where {m{% d > 0 %}} should be taken as a tight bound on {m{% \max_{i=1,\cdots,K} \Delta_i%}}
  *)


(** Use to instanciate a [Bandit] from [MakeDecayingEpsilonGreedy] .*)
module type DecayingEpsilonGreedyParam = sig
  val k : int
  (** The number of actions {m{% K %}} .*)
  val d : float
  (** The {m{% d %}} parameter, a tight lower bound on {m{% \max_{i=1,\cdots,K} \Delta_i %}}.*)
end

(** The Epsilon-Greedy Bandit with the decaying exploration rate from [[5]].*)
module MakeDecayingEpsilonGreedy (P : DecayingEpsilonGreedyParam) : Bandit

(**

  {3:mdf MakeDecayingEpsilonGreedy: {m{% \epsilon_n%}}-Greedy with the decaying rate from [[5]].}

  This uses a fixed exploration {m{% \epsilon%}}.
  *)

(** Use to instanciate a [Bandit] from [MakeEpsilonGreedy] .*)
module type EpsilonGreedyParam = sig
  val k : int
  (** The number of actions {m{% K %}} .*)
  val epsilon : float
  (** The {m{% \epsilon %}} parameter.*)
end

(** The Epsilon-Greedy Bandit with a fixed exploration rate.*)
module MakeEpsilonGreedy (P : EpsilonGreedyParam) : Bandit

(**
  {2:mdf Exp3 family of algorithms.}

  {3:mdf MakeExp3: EXP3 with a parametrizable rate.}

  At round {m{% t%}}, the EXP3 algorithm[[1]] draws.
  *)

(** The Exp3 Bandit for adversarial regret minimization.*)
module MakeExp3 (P : RateBanditParam) : Bandit

(**
  {2:mdf More Functors: The doubling trick.}

  Reward normalization in online stochastic and/or adversarial learning is a hard problem.
  While this is well studied in online learning [[2]][[3]][[4]], it isn't clear how
  to manage this in the case of bandits.
  The [WrapRange] Functors applies a heuristic solution known as the doubling trick.
  A convenience [WrapRange01] is provided for rewards that are initially thought
  to lie in {m{% [0,1]%}}.
  *)

(** A Reward range.*)
module type RangeParam = sig
  (** The upper value of the range*)
  val upper : float
  (** The lower value of the range*)
  val lower : float
end

(** The WrapRange functor wraps a bandit algorithm with the doubling trick.
  This heuristic allows to use a bandit algorithm without knowing the reward
  ranges. All rewards are linearly rescaled to a range (initially given by a RangeParam).
  When a value is observed above the range, the bandit algorithm is restarted
  and the range interval is doubled in that direction.  *)
module WrapRange (R:RangeParam) (P:RateBanditParam) (B : functor (Pb:RateBanditParam) -> Bandit) : Bandit

(** The WrapRange01 functor is a convenience aliasing of WrapRange with an
  initial "standard" range of [0,1].  *)
module WrapRange01 (P:RateBanditParam) (B : functor (Pb:RateBanditParam) -> Bandit) : Bandit

(**
  {1:ex Examples}

  see test/test.ml for an example of bandit use.

  {1:refs References}

  [[1]] {{:https://arxiv.org/abs/1204.5721}Regret Analysis of Stochastic and
  Nonstochastic Multi-armed Bandit Problems},
  Sebastien Bubeck and Nicolo Cesa-Bianchi.

  [[2]] {{:jmlr.org/papers/volume12/duchi11a/duchi11a.pdf}Adaptive Subgradient
  methods for Online Learning and Stochastic Optimization},
  John Duchi , Elad Hazan and Yoram Singer.

  [[3]] {{:arxiv.org/abs/1305.6646}Normalized Online Learning},
  Stephane Ross, Paul Mineiro, John Langford

  [[4]] {{:https://arxiv.org/abs/1601.01974}Scale-Free Online Learning},
  Francesco Orabona, Dávid Pál

  [[5]] {{:homes.di.unimi.it/~cesabian/Pubblicazioni/ml-02.pdf}Finite-time 
  Analysis of the Multiarmed Bandit Problem},
  Peter Auer, Nicolo Cesa-Bianchi, Paul Fischer
  *)

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

