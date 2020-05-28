<div class="navbar">

[Previous](Obandit.RateBanditParam.html "Obandit.RateBanditParam")
 [Up](Obandit.html "Obandit")
 [Next](Obandit.EpsilonGreedyParam.html "Obandit.EpsilonGreedyParam")

</div>

# Module type [Obandit.DecayingEpsilonGreedyParam](type_Obandit.DecayingEpsilonGreedyParam.html)

    module type DecayingEpsilonGreedyParam = sig .. end

<div class="info modtype top">

<div class="info-desc">

Use to instanciate a `Bandit` from `MakeDecayingEpsilonGreedy` .

</div>

</div>

-----

    val k : int

<div class="info">

<div class="info-desc">

The number of actions $ K $ .

</div>

</div>

    val c : float

<div class="info">

<div class="info-desc">

The $ c$ hyperparameter.

</div>

</div>

    val d : float

<div class="info">

<div class="info-desc">

The $ d$ hyperparameter, a tight lower bound on $ \\max\_{i=1,\\cdots,K}
\\Delta\_i $.

</div>

</div>
