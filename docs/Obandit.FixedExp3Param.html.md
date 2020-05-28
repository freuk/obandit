<div class="navbar">

[Previous](Obandit.EpsilonGreedyParam.html "Obandit.EpsilonGreedyParam")
 [Up](Obandit.html "Obandit")
 [Next](Obandit.HorizonExp3Param.html "Obandit.HorizonExp3Param")

</div>

# Module type [Obandit.FixedExp3Param](type_Obandit.FixedExp3Param.html)

    module type FixedExp3Param = sig .. end

<div class="info modtype top">

<div class="info-desc">

Use to instanciate a `Bandit` from `MakeFixedExp3` .

</div>

</div>

-----

    val k : int

<div class="info">

<div class="info-desc">

The number of actions $ K $ .

</div>

</div>

    val eta : float

<div class="info">

<div class="info-desc">

The fixed learning rate $ \\eta $.

</div>

</div>
