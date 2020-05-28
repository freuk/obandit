<div class="navbar">

 [Up](Obandit.html "Obandit")
 [Next](Obandit.AlphaPhiUCBParam.html "Obandit.AlphaPhiUCBParam")

</div>

# Module type [Obandit.Bandit](type_Obandit.Bandit.html)

    module type Bandit = sig .. end

<div class="info modtype top">

<div class="info-desc">

A bandit algorithm.

</div>

</div>

-----

    type bandit 

<div class="info">

<div class="info-desc">

The internal data structure of the bandit algorithm.

</div>

</div>

    val initialBandit : bandit

<div class="info">

<div class="info-desc">

The initial state of the bandit algorithm.

</div>

</div>

    val step : bandit -> float -> int * bandit

<div class="info">

<div class="info-desc">

`step r` advances the bandit game one step, where `r` is the reward for
the last action. The result of this call is the next action, encoded as
an integer in $ \\{ 0, \\cdots , K-1 \\} $, and the new state of the
bandit. The reward range depends on the bandit algorithm in use and the
first reward provided to the algorithm is discarded.

</div>

</div>
