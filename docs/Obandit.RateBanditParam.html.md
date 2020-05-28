<div class="navbar">

[Previous](Obandit.KBanditParam.html "Obandit.KBanditParam")
 [Up](Obandit.html "Obandit")
 [Next](Obandit.DecayingEpsilonGreedyParam.html "Obandit.DecayingEpsilonGreedyParam")

</div>

# Module type [Obandit.RateBanditParam](type_Obandit.RateBanditParam.html)

    module type RateBanditParam = sig .. end

<div class="info modtype top">

<div class="info-desc">

Use to instanciate algorithms that need a parametrizable rate.

</div>

</div>

-----

    val k : int

<div class="info">

<div class="info-desc">

The number of actions $K$ .

</div>

</div>

    val rate : int -> float

<div class="info">

<div class="info-desc">

The rate. Can be fixed or decaying.

</div>

</div>
