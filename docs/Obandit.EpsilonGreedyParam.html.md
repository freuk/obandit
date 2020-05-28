<div class="navbar">

[Previous](Obandit.DecayingEpsilonGreedyParam.html "Obandit.DecayingEpsilonGreedyParam")
 [Up](Obandit.html "Obandit")
 [Next](Obandit.FixedExp3Param.html "Obandit.FixedExp3Param")

</div>

# Module type [Obandit.EpsilonGreedyParam](type_Obandit.EpsilonGreedyParam.html)

    module type EpsilonGreedyParam = sig .. end

<div class="info modtype top">

<div class="info-desc">

Use to instanciate a `Bandit` from `MakeEpsilonGreedy` .

</div>

</div>

-----

    val k : int

<div class="info">

<div class="info-desc">

The number of actions $ K $ .

</div>

</div>

    val epsilon : float

<div class="info">

<div class="info-desc">

The $ \\epsilon $ parameter.

</div>

</div>
