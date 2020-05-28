<div class="navbar">

[Previous](Obandit.FixedExp3Param.html "Obandit.FixedExp3Param")
 [Up](Obandit.html "Obandit")
 [Next](Obandit.RangeParam.html "Obandit.RangeParam")

</div>

# Module type [Obandit.HorizonExp3Param](type_Obandit.HorizonExp3Param.html)

    module type HorizonExp3Param = sig .. end

<div class="info modtype top">

<div class="info-desc">

Use to instanciate a `Bandit` from `MakeHorizonExp3` .

</div>

</div>

-----

    val k : int

<div class="info">

<div class="info-desc">

The number of actions $K$ .

</div>

</div>

    val n : int

<div class="info">

<div class="info-desc">

The $ n $ parameter, the horizon to optimize for.

</div>

</div>
