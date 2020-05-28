<div class="navbar">

 [Up](index.html "Index")  

</div>

# Module [Obandit](type_Obandit.html)

    module Obandit: sig .. end

<div class="info module top">

<div class="info-desc">

Ocaml Multi-Armed Bandits

Obandit is an Ocaml module for multi-armed bandits. It supports the EXP,
UCB and Epsilon-greedy family of algorithms.

*Version 0.3.4 - [homepage](http://freux.fr/oss/obandit.html%20)*

![rabbits](http://freux.fr/kroliki.jpg)

## Bandit Modules

This library implements multi-armed bandits as modules. A bandit module
is obtained by calling a functor with a bandit module parameter. The
parameter usually gives the number $K$ of arms and the hyperparameters
of the bandit.

</div>

</div>

-----

    module type Bandit = sig .. end

<div class="info">

A bandit algorithm.

</div>

$$ $$

Bandit modules are instanciated using functors. Depending on the
algorithm type used, the module parameter varies.

For instance, the UCB1 bandit module for 3 arms is obtained with:

`module UCB1 = let module P = struct let k=3 end in MakeUCB1(P)`

The following algorithms are available:

### The UCB family of algorithms.

We use the viewpoint of the survey `[1]`.

#### MakeAlphaPhiUCB: $(\\alpha,\\psi)$-UCB

At time $t$, the $(\\alpha,\\psi)$-UCB algorithm`[1]` is taking action:

$$ \\argmax\_{i=1,\\cdots,K} \\quad \\left\[
\\widehat{\\mu\_i}+(\\psi^{\*})^{-1}\\left(\\frac{\\alpha\\ln t}{T\_i}
\\right) \\right\] $$

where $\\alpha \> 0$ is a hyperparameter, $\\widehat{\\mu\_i}$ is the
estimate of the average reward of arm $i$, $T\_i$ is the number of times
arm $ i$ was visited so far and $\\psi^\*$ denotes the Legendre-Fenchel
transform of a convex function $\\psi$.

The pseudo-regret $\\bar{R\_n}$ has the following bound at round $n$: $$
\\bar{R\_n} \\leq \\sum\_{i:\\Delta\_i \> 0} \\left( \\frac{\\alpha
\\Delta\_i}{\\psi^\* (\\Delta\_i / 2 )} \\ln n + \\frac{\\alpha
}{\\alpha-2 } \\right) $$

where $ \\Delta\_i = \\mu^\* - \\mu\_i $ is the suboptimality parameter
of arm $ i$.

    type banditEstimates = {

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><code>  </code></td>
<td style="text-align: left;"><code>t : int</code>;</td>
<td style="text-align: left;"><code>(*</code></td>
<td style="text-align: left;"><div class="info">
<div class="info-desc">
<p>The index of the step</p>
</div>
</div></td>
<td style="text-align: left;"><code>*)</code></td>
</tr>
<tr class="even">
<td style="text-align: left;"><code>  </code></td>
<td style="text-align: left;"><code>a : int</code>;</td>
<td style="text-align: left;"><code>(*</code></td>
<td style="text-align: left;"><div class="info">
<div class="info-desc">
<p>The last action taken.</p>
</div>
</div></td>
<td style="text-align: left;"><code>*)</code></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><code>  </code></td>
<td style="text-align: left;"><code>nVisits : int list</code>;</td>
<td style="text-align: left;"><code>(*</code></td>
<td style="text-align: left;"><div class="info">
<div class="info-desc">
<p>The visit counts by arm.</p>
</div>
</div></td>
<td style="text-align: left;"><code>*)</code></td>
</tr>
<tr class="even">
<td style="text-align: left;"><code>  </code></td>
<td style="text-align: left;"><code>u : float list</code>;</td>
<td style="text-align: left;"><code>(*</code></td>
<td style="text-align: left;"><div class="info">
<div class="info-desc">
<p>The cumulative arm reward observations.</p>
</div>
</div></td>
<td style="text-align: left;"><code>*)</code></td>
</tr>
</tbody>
</table>

}

<div class="info">

<div class="info-desc">

The inner state of a bandit that maintains estimates of arm means.

</div>

</div>

    module type AlphaPhiUCBParam = sig .. end

<div class="info">

Use to instanciate a `Bandit` from `MakeAlphaPhiUCB` by giving $\\alpha$
and $\\phi$.

</div>

    module MakeAlphaPhiUCB: functor (P : AlphaPhiUCBParam) -> Bandit  with type bandit = banditEstimates

<div class="info">

The $(\\alpha,\\psi)$-UCB Bandit for stochastic regret minimization
described in `[1]`.

</div>

#### MakeAlphaUCB: $\\alpha$-UCB

The $\\alpha$-UCB algorithm`[5]` uses $ \\psi(\\lambda) = \\lambda^2 / 8
$. It chooses the action:

$$ \\argmax\_{i=1,\\cdots,K} \\left\[ \\widehat{\\mu\_i} + \\sqrt{
\\frac{\\alpha \\ln t}{2 T\_i} } \\right\] $$

This gives a pseudo-regret bound of:

$$ \\bar{ R\_n} \\leq \\sum\_{i:\\Delta\_i \> 0} \\left( \\frac{2
\\alpha} { \\Delta\_i } \\ln n + \\frac{\\alpha}{\\alpha - 2} \\right)
$$

    module type AlphaUCBParam = sig .. end

<div class="info">

Use to instanciate a `Bandit` from `MakeAlphaUCB` by giving $\\alpha$.

</div>

    module MakeAlphaUCB: functor (P : AlphaUCBParam) -> Bandit  with type bandit = banditEstimates

<div class="info">

The $\\alpha$-UCB Bandit for stochastic regret minimization described in
`[1]` .

</div>

#### MakeUCB1: UCB1

The UCB1 algorithm`[5]` uses $\\alpha = 4$. It chooses the action:

$$ \\argmax\_{i=1,\\cdots,K} \\left\[ \\widehat{\\mu\_i} + \\sqrt{
\\frac{2 \\ln t}{T\_i} } \\right\] $$

At round $ n$, this gives a pseudo-regret bound of:

$$ \\bar{R\_n} \\leq \\sum\_{i:\\Delta\_i \> 0} \\left(
\\frac{8}{\\Delta\_i} \\ln n + 2 \\right) $$

    module type KBanditParam = sig .. end

<div class="info">

Use to instanciate a `Bandit` from `MakeUCB1`.

</div>

    module MakeUCB1: functor (P : KBanditParam) -> Bandit  with type bandit = banditEstimates

<div class="info">

The UCB1 Bandit for stochastic regret minimization .

</div>

### The Epsilon-Greedy family of algorithms.

#### MakeParametrizableEpsilonGreedy: $\\epsilon$-Greedy with a parametrizable rate.

At round $t$, the $ \\epsilon\_t$-Greedy algorithm`[5]` takes action
$\\argmax\_{i=1,\\cdots,K} \\widehat{\\mu\_i} $ with probability $
1-\\epsilon\_t$ and an uniformly random action with probability $
\\epsilon\_t$.

    module type RateBanditParam = sig .. end

<div class="info">

Use to instanciate algorithms that need a parametrizable rate.

</div>

    module MakeParametrizableEpsilonGreedy: functor (P : RateBanditParam) -> Bandit  with type bandit = banditEstimates

<div class="info">

The $\\epsilon$-Greedy Bandit with a parametrizable exploration rate.

</div>

#### MakeDecayingEpsilonGreedy: $ \\epsilon\_n$-Greedy with the decaying rate from `[5]`.

This uses the exploration rate decay: $$ \\epsilon\_t = \\min \\left\\{
1, \\frac{cK}{d^2 t} \\right\\} $$ where $ d \> 0 $ should be taken as a
tight lower bound on $ \\max\_{i=1,\\cdots,K} \\Delta\_i$ and $ c \> 0$
is a hyperparameter.

    module type DecayingEpsilonGreedyParam = sig .. end

<div class="info">

Use to instanciate a `Bandit` from `MakeDecayingEpsilonGreedy` .

</div>

    module MakeDecayingEpsilonGreedy: functor (P : DecayingEpsilonGreedyParam) -> Bandit  with type bandit = banditEstimates

<div class="info">

The Epsilon-Greedy Bandit with the decaying exploration rate from `[5]`.

</div>

#### MakeEpsilonGreedy: $ \\epsilon\_n$-Greedy with a fixed exploration rate.

This uses a fixed exploration rate $ \\epsilon$.

    module type EpsilonGreedyParam = sig .. end

<div class="info">

Use to instanciate a `Bandit` from `MakeEpsilonGreedy` .

</div>

    module MakeEpsilonGreedy: functor (P : EpsilonGreedyParam) -> Bandit  with type bandit = banditEstimates

<div class="info">

The Epsilon-Greedy Bandit with a fixed exploration rate.

</div>

### The Exp3 family of algorithms.

#### MakeExp3: EXP3 with a parametrizable rate.

At round $ t$, the EXP3 algorithm`[1]` draws an arm from a probability
distribution $ p$ and updates this distribution with a softmax operator:

$ p\_{i,t+1} = \\frac{\\exp ( - \\eta\_t
\\widetilde{L\_{i,t}})}{\\sum{k=1}^{K}\\text{exp}(-\\eta\_t
\\widetilde{L\_{k,t}})} $

where $\\widetilde{L\_{i,t}}$ is the cumulative probability-normalized
loss at time $ t$ of arm $i$, $\\eta\_t$ is the rate at time $t$.

    type banditPolicy = {

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><code>  </code></td>
<td style="text-align: left;"><code>t : int</code>;</td>
<td style="text-align: left;"><code>(*</code></td>
<td style="text-align: left;"><div class="info">
<div class="info-desc">
<p>The index of the step $t$.</p>
</div>
</div></td>
<td style="text-align: left;"><code>*)</code></td>
</tr>
<tr class="even">
<td style="text-align: left;"><code>  </code></td>
<td style="text-align: left;"><code>a : int</code>;</td>
<td style="text-align: left;"><code>(*</code></td>
<td style="text-align: left;"><div class="info">
<div class="info-desc">
<p>The last action taken.</p>
</div>
</div></td>
<td style="text-align: left;"><code>*)</code></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><code>  </code></td>
<td style="text-align: left;"><code>w : float list</code>;</td>
<td style="text-align: left;"><code>(*</code></td>
<td style="text-align: left;"><div class="info">
<div class="info-desc">
<p>The weights of the arm that define the policy.</p>
</div>
</div></td>
<td style="text-align: left;"><code>*)</code></td>
</tr>
</tbody>
</table>

}

<div class="info">

<div class="info-desc">

The internal state of an Exp3 bandit

</div>

</div>

    module MakeExp3: functor (P : RateBanditParam) -> Bandit  with type bandit = banditPolicy

<div class="info">

The Exp3 Bandit for adversarial regret minimization with a
parametrizable learning rate.

</div>

#### MakeDecayingExp3: EXP3 with the decaying rate from `[1]`.

This variant uses the learning rate decay:

$$ \\eta\_t = \\sqrt{\\frac{ln K}{tK}} $$

and enjoys the pseudo-regret bound: $$ \\bar{R\_n} \\leq 2 \\sqrt{nK
\\ln K} $$

    module MakeDecayingExp3: functor (P : KBanditParam) -> Bandit  with type bandit = banditPolicy

<div class="info">

The Exp3 Bandit for adversarial regret minimization with a decaying
learning rate as per `[1]`.

</div>

#### MakeFixedExp3: EXP3 with a fixed rate.

This uses a fixed rate $\\eta$.

    module type FixedExp3Param = sig .. end

<div class="info">

Use to instanciate a `Bandit` from `MakeFixedExp3` .

</div>

    module MakeFixedExp3: functor (P : FixedExp3Param) -> Bandit  with type bandit = banditPolicy

<div class="info">

The Exp3 Bandit for adversarial regret minimization with a decaying
learning rate as per `[1]`.

</div>

#### MakeHorizonExp3: EXP3 with a known horizon `[1]`.

This variant optimizes for a known horizon $ n$ and uses the learning
rate:

$$ \\eta = \\sqrt{\\frac{2 ln K}{nK}} $$

It has the pseudo-regret bound:

$$ \\bar{R\_n} \\leq \\sqrt{2 nK \\ln K} $$

    module type HorizonExp3Param = sig .. end

<div class="info">

Use to instanciate a `Bandit` from `MakeHorizonExp3` .

</div>

    module MakeHorizonExp3: functor (P : HorizonExp3Param) -> Bandit  with type bandit = banditPolicy

<div class="info">

The Exp3 Bandit for adversarial regret minimization with a horizon-based
learning rate as per `[1]`.

</div>

### More Functors: The doubling trick.

Reward normalization in online stochastic and/or adversarial learning is
a hard problem. While this is well studied in online learning
`[2]``[3]``[4]`, there is no well studied procedure for bandits yet. The
`WrapRange` Functors applies the heuristic solution known as the
doubling trick.

The WrapRange functor wraps a bandit algorithm with the doubling trick.
This heuristic allows to use a bandit algorithm without knowing the
reward ranges. All rewards are linearly rescaled to a range (initially
given by a RangeParam). When a value is observed above the range, the
bandit algorithm is restarted and the range interval is doubled in that
direction.

A convenience `WrapRange01` is provided for rewards that are initially
thought to lie in $\\left\[0,1\\right\]$.

    module type RangeParam = sig .. end

<div class="info">

A Reward range.

</div>

    type rangedAction = 

<table>
<tbody>
<tr class="odd">
<td style="text-align: left;"><code>|</code></td>
<td style="text-align: left;"><code>Reset of int</code></td>
</tr>
<tr class="even">
<td style="text-align: left;"><code>|</code></td>
<td style="text-align: left;"><code>Action of int</code></td>
</tr>
</tbody>
</table>

<div class="info">

<div class="info-desc">

A ranged action: Action a in normal course of action, Reset a in case \*
the bandit was just restarted.

</div>

</div>

    type 'b rangedBandit = {

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><code>  </code></td>
<td style="text-align: left;"><code>bandit : 'b</code>;</td>
<td style="text-align: left;"><code>(*</code></td>
<td style="text-align: left;"><div class="info">
<div class="info-desc">
<p>The original type of the bandit.</p>
</div>
</div></td>
<td style="text-align: left;"><code>*)</code></td>
</tr>
<tr class="even">
<td style="text-align: left;"><code>  </code></td>
<td style="text-align: left;"><code>u : float</code>;</td>
<td style="text-align: left;"><code>(*</code></td>
<td style="text-align: left;"><div class="info">
<div class="info-desc">
<p>The upper reward bound.</p>
</div>
</div></td>
<td style="text-align: left;"><code>*)</code></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><code>  </code></td>
<td style="text-align: left;"><code>l : float</code>;</td>
<td style="text-align: left;"><code>(*</code></td>
<td style="text-align: left;"><div class="info">
<div class="info-desc">
<p>The lower reward bound.</p>
</div>
</div></td>
<td style="text-align: left;"><code>*)</code></td>
</tr>
</tbody>
</table>

}

<div class="info">

<div class="info-desc">

The type of a bandit with a range.

</div>

</div>

    module type RangedBandit = sig .. end

<div class="info">

The type of a bandit with reward scaling.

</div>

    module WrapRange: functor (R : RangeParam) -> functor (B : Bandit) -> RangedBandit  with type bandit = B.bandit

<div class="info">

The WrapRange functor wraps a bandit algorithm with the doubling trick.

</div>

    module WrapRange01: functor (B : Bandit) -> RangedBandit  with type bandit = B.bandit

<div class="info">

The WrapRange01 functor is a convenience aliasing of WrapRange with an
initial "standard" range of $ \\left\[ 0,1 \\right\] $.

</div>

## Examples

see test/test.ml for an example of bandit use.

## References

`[1]` [Regret Analysis of Stochastic and Nonstochastic Multi-armed
Bandit Problems](http://arxiv.org/abs/1204.5721), Sebastien Bubeck and
Nicolo Cesa-Bianchi.

`[2]` [Adaptive Subgradient methods for Online Learning and Stochastic
Optimization](http://jmlr.org/papers/volume12/duchi11a/duchi11a.pdf),
John Duchi , Elad Hazan and Yoram Singer.

`[3]` [Normalized Online Learning](http://arxiv.org/abs/1305.6646),
Stephane Ross, Paul Mineiro, John Langford

`[4]` [Scale-Free Online Learning](http://arxiv.org/abs/1601.01974),
Francesco Orabona, Dávid Pál

`[5]` [Finite-time Analysis of the Multiarmed Bandit
Problem](http://homes.di.unimi.it/~cesabian/Pubblicazioni/ml-02.pdf),
Peter Auer, Nicolo Cesa-Bianchi, Paul Fischer
